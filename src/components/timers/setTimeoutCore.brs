' @import /components/functionCall.brs
' @import /components/rokuComponents/Timer.brs
' @import /components/uuid.brs

' Executes given callback after given timeout.
' @param {Function} callback - Function that is fired.
' @param {Float} timeout - Measured in seconds.
' @param {Object} [context=Invalid] - Additional scope of execution.
' @returns {String} - ID of the timer.
function setTimeoutCore(callback as Object, timeout as Float, context = Invalid as Object) as String
  _timer = Timer()
  _timer.id = uuid()
  _timer.repeat = false
  _timer.duration = timeout
  _timer.observeFieldScoped("fire", "setTimeout_onTimerFired")
  _timer.control = "start"

  if (m["$$setTimeoutData"] = Invalid)
    m["$$setTimeoutData"] = {}
  end if

  m["$$setTimeoutData"][_timer.id] = {
    timer: _timer,
    callback: callback,
    context: context,
  }

  return _timer.id
end function

' @private
sub setTimeout_onTimerFired(event as Object)
  if (m["$$setTimeoutData"] = Invalid)
    return
  end if

  timerId = event.getNode()
  timeoutData = m["$$setTimeoutData"][timerId]

  if (timeoutData <> Invalid)
    functionCall(timeoutData.callback, [], timeoutData.context)

    m["$$setTimeoutData"].delete(timerId)
  end if
end sub
