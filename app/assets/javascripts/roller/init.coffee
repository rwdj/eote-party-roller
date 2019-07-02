# init.coffee
#
# Initialises onload events
#
#= require ./lib/struct/selector_group
#= require ./lib/roll_handler
#= require ./lib/buttons

document.addEventListener 'turbolinks:load', @initButtons
document.addEventListener 'turbolinks:load', @initRollHandler

