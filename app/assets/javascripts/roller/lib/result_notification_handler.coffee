# Handles sending results for notifications

class @ResultNotificationHandler
  @opts: {}

  @send: (data) ->
    setTimeout @flashIndex, 0
    return false if !window.notifyable || window.isFocused

    title = "#{data.roller} rolled."
    result_string = @parseResults(JSON.parse(data.result))
    new Notification(title, { body: "#{result_string} — #{data.purpose}" })

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
