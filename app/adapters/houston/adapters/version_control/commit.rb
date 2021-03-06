module Houston
  module Adapters
    module VersionControl
      class Commit
        
        def initialize(attributes={})
          @original = attributes[:original]
          @sha = attributes[:sha]
          @message = attributes[:message]
          @authored_at = attributes[:authored_at]
          @author_name = attributes[:author_name]
          @author_email = attributes[:author_email]
          @committed_at = attributes[:committed_at]
          @committer_name = attributes[:committer_name]
          @committer_email = attributes[:committer_email]
        end
        
        attr_reader :original, :sha, :message, :authored_at, :author_name, :author_email,
          :committed_at, :committer_name, :committer_email
        
        def to_s
          sha[0...7]
        end
        
      end
    end
  end
end
