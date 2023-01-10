' @import /components/functionCall.brs
' @import /components/rokuComponents/Timer.brs
' @import /components/uuid.brs

' Executes given callback every given timeout until it is stopped by clearInterval function call.
' @param {Function} callback - Function that is fired.
' @param {Float} interval - Measured in seconds.
' @param {Object} [context=Invalid] - Additional scope of execution.
' @returns {String} - ID of the timer.
function setInterval(callback as Function, interval as Float, context = Invalid as Object) as String
  _timer = Timer()
  _timer.id = uuid()
  _timer.repeat = true
  _timer.duration = interval
  _timer.observeFieldScoped("fire", "setInterval_onTimerFired")
  _timer.control = "start"

  if (m["$$setIntervalData"] = Invalid)
    m["$$setIntervalData"] = {}
  end if

  m["$$setIntervalData"][_timer.id] = {
    timer: _timer,
    callback: callback,
    context: context,
  }

  return _timer.id
end function

' @private
sub setInterval_onTimerFired(event as Object)
  if (m["$$setIntervalData"] = Invalid)
    return
  end if

  timerId = event.getNode()
  interval = m["$$setIntervalData"][timerId]

  if (interval <> Invalid)
    functionCall(interval.callback, [], interval.context)
  end if
end sub
