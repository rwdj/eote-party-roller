# Impliments how a page (imlimented by tab navigation) acts

class Page
  @all = []

  constructor: (@node) ->
    @constructor.all.push @
    page = @
    for pageBtn in @pageButtons()
      pageBtn.addEventListener 'click', ->
        page.activate()

  activate: ->
    page.deactivate() for page in @constructor.all
    @node.classList.remove('closed')
    @node.classList.add('open')

  deactivate: ->
    @node.classList.remove('open')
    @node.classList.add('closed')

  pageButtons: -> document.querySelectorAll ".btn.page[data-page='#{@node.id}']"

document.addEventListener 'turbolinks:load', ->
  new Page(page) for page in document.querySelectorAll '.page.openable'
