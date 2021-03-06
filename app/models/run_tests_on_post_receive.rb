class RunTestsOnPostReceive
  
  def self.instance
    @instance
  end
  
  def self.begin!
    @instance = self.new.tap(&:begin!)
  end
  
  def begin!
    Rails.logger.info "\e[31;1mSetting up observers for RunTestsOnPostReceive\e[0m"
    
    # Here's how this works:
    #
    #   1. GitHub receives a `git push` and triggers all Web Hooks:
    #      POST /projects/houston/hooks/post_receive.
    #   2. Houston receives this request and fires the
    #      'hooks:post_receive' event.
    #   3. Houston creates a TestRun and tells a CI server to build
    #      then corresponding job:
    #      POST /job/houston/buildWithParameters.
    Houston.observer.on "hooks:post_receive" do |project, params|
      Rails.logger.info "\e[31;1m[hooks:post_receive] creating a TestRun\e[0m"
      create_a_test_run(project, params)
    end
    
    #   4. Houston notifies GitHub that the test run has started:
    #      POST /repos/houstonmc/houston/statuses/:sha
    Houston.observer.on "test_run:start" do |test_run|
      Rails.logger.info "\e[31;1m[test_run:start] publishing status on GitHub\e[0m"
      publish_status_to_github(test_run)
    end
    
    #   5. Jenkins checks out the project, runs the tests, and
    #      tells Houston that it is finished:
    #      POST /projects/houston/hooks/post_build.
    #   6. Houston receives the request and fires the
    #      'hooks:post_build' event.
    #   7. Houston updates the TestRun,
    #      fetching additional details from Jenkins:
    #      GET /job/houston/19/testReport/api/json
    Houston.observer.on "hooks:post_build" do |project, params|
      Rails.logger.info "\e[31;1m[hooks:post_build] fetching TestRun results\e[0m"
      fetch_test_run_results(project, params)
    end
    
    #   8. Houston emails results of the TestRun.
    Houston.observer.on "test_run:complete" do |test_run|
      Rails.logger.info "\e[31;1m[test_run:complete] emailing TestRun results\e[0m"
      email_test_run_results(test_run)
    end
    
    #   9. Houston publishes results to GitHub:
    #      POST /repos/houstonmc/houston/statuses/:sha
    Houston.observer.on "test_run:complete" do |test_run|
      Rails.logger.info "\e[31;1m[test_run:complete] publishing status on GitHub\e[0m"
      publish_status_to_github(test_run)
    end
    
    #  10. Houston publishes results to Code Climate.
    Houston.observer.on "test_run:complete" do |test_run|
      Rails.logger.info "\e[31;1m[test_run:complete] publishing status on CodeClimate\e[0m"
      publish_coverage_to_code_climate(test_run)
    end
  end
  
  
  
  def create_a_test_run(project, params)
    unless project.has_ci_server?
      Rails.logger.warn "[hooks:post_receive] the project #{project.name} is not configured to be used with a Continuous Integration server"
      return
    end
    
    payload = PostReceivePayload.new(params)
    
    unless payload.commit
      Rails.logger.error "[hooks:post_receive] no commit found in payload"
      return
    end
    
    test_run = project.test_runs.find_by_sha(payload.commit)
    
    if test_run
      Rails.logger.warn "[hooks:post_receive] a test run exists for #{test_run.short_commit}; doing nothing"
      return
    end
    
    test_run = TestRun.new(
      project: project,
      sha: payload.commit,
      agent_email: payload.agent_email,
      branch: payload.branch)
    
    notify_of_invalid_configuration(test_run) do
      test_run.start!
    end
  end
  
  
  def fetch_test_run_results(project, params)
    commit, results_url = params.values_at(:commit, :results_url)
    test_run = project.test_runs.find_by_sha(commit)
    
    unless test_run
      Rails.logger.warn "[hooks:post_build] no test run found for project '#{project.slug}' and commit '#{commit}'"
      return
    end
    
    if results_url.blank?
      message = "#{project.ci_server_name} is not appropriately configured to build #{project.name}."
      additional_info = "#{project.ci_server_name} did not supply 'results_url' when it triggered the post_build hook"
      ProjectNotification.ci_configuration_error(test_run, message, additional_info: additional_info).deliver!
      return
    end
    
    notify_of_invalid_configuration(test_run) do
      test_run.completed!(results_url)
    end
  end
  
  
  def email_test_run_results(test_run)
    ProjectNotification.test_results(test_run).deliver!
  end
  
  
  
  def publish_status_to_github(test_run)
    return unless test_run.project.repo.respond_to? :commit_status_url
    Github::CommitStatusReport.publish!(test_run)
  rescue
    Houston.report_exception $!
    message = "Houston was unable to publish your commit status to GitHub"
    ProjectNotification.ci_configuration_error(test_run, message, additional_info: $!.message).deliver!
  end
  
  
  
  def publish_coverage_to_code_climate(test_run)
    return if test_run.project.code_climate_repo_token.blank?
    CodeClimate::CoverageReport.publish!(test_run)
  rescue
    Houston.report_exception $!
    message = "Houston was unable to publish your code coverage to Code Climate"
    ProjectNotification.ci_configuration_error(test_run, message, additional_info: $!.message).deliver!
  end
  
  
  
private
  
  def notify_of_invalid_configuration(test_run)
    begin
      yield
    rescue Houston::Adapters::CIServer::Error
      project = test_run.project
      message = "#{project.ci_server_name} is not appropriately configured to build #{project.name}."
      ProjectNotification.ci_configuration_error(test_run, message, additional_info: $!.message).deliver!
    end
  end
  
end
