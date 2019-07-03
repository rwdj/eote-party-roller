# Handles sending notifications to users while the window is inactive

# set window.isFocused
window.addEventListener 'blur', -> window.isFocused = false
window.addEventListener 'focus', -> window.isFocused = true

# set window.hasNotificationPermission
if @Notification
  @Notification.requestPermission (permission) ->
    window.notifyable = { 'granted': true, 'denied': false }[permission]
