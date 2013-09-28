###
#
#  main.coffee
#
###

###
# Define Global Variables
###

root = exports ? this
root.path = (window.location.pathname).substr(1)

$ ->

  ###
  # Init Event
  ###
  socket = io.connect()