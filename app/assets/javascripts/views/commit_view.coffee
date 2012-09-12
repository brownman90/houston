class window.CommitView extends Backbone.View
  tagName: 'li'
  className: 'commit'
  
  initialize: ->
    @renderer = Handlebars.compile($('#commit_template').html())
  
  render: ->
    $el = $(@el)
    json = @model.toJSON()
    json['github_url'] = $el.closest('.project').attr('data-github-url')
    json['message'] = json['message'].replace(/\[#(\d+)\]/g, '') # remove ticket numbers)
    $el.html @renderer(json)
    @