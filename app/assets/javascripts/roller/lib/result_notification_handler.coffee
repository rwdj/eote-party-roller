# Handles sending results for notifications

class @ResultNotificationHandler
  @opts: {}

  @send: (data) ->
    setTimeout @flashIndex, 0
    return false if !window.notifyable || window.isFocused

    result_string = @parseResults(JSON.parse(data.result))
    title = "#{data.roller} rolled: #{data.purpose}"
    new Notification(title, { body: result_string })

  @parseResults: (results) ->
    Object.keys(results).map((resultType) ->
      shortResultType = resultType[0].toUpperCase()
      if resultType[0] in ['d', 't'] then shortResultType += resultType[1]

      [shortResultType, results[resultType]].join ': '
    ).join ', '

  @flashIndex: ->
    timeInterval = 1000
    for i in [0..1]
      setTimeout(->
        for indexBtn in document.querySelectorAll('.btn.toggle-index')
          indexBtn.classList.toggle('lit')
      timeInterval * i)
