# Handles sending results for notifications

class @ResultNotificationHandler
  @opts: {}

  @send: (dice_pool) ->
    setTimeout @flashIndex, 0
    return false if !window.notifyable || window.isFocused

    results = JSON.parse(dice_pool.results)
    result_string = @parseResults(JSON.parse(results.pool))
    title = "#{dice_pool.roller} rolled: #{dice_pool.purpose}"
    new Notification(title, { body: result_string })

  @parseResults: (results) ->
    # console.log results
    Object.keys(results).map((resultType) ->
      shortResultType = resultType[0].toUpperCase()
      if resultType[0] in ['d', 't'] then shortResultType += resultType[1]

      [shortResultType, results[resultType]].join ': '
    ).join ', '

  @flashIndex: ->
    timeInterval = 1000
    for i in [0..1]
      setTimeout(->
        indexBtns = document.querySelectorAll(".btn.page[data-page='rolls']")
        indexBtn.classList.toggle('lit') for indexBtn in indexBtns
      timeInterval * i)
