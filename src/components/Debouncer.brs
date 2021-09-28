' @import /components/timers/clearTimeout.brs
' @import /components/timers/setTimeout.brs

' Based on https://lodash.com/docs/4.17.15#debounce
' Creates a debounced function that delays invoking callback until after wait seconds have elapsed since the last time
' the debounced function was invoked.
' @class
' @param {Function} callback - The function to debounce.
' @param {Float} [waitTime=0] - The number of seconds to delay.
' @param {Object} [context=Invalid] - The additional context in which callback is fired.
function Debouncer(callback as Function, waitTime = 0 as Float, context = Invalid as Object) as Object
  prototype = {}

  prototype._callback = callback
  prototype._context = context
  prototype._timeoutId = ""
  prototype._waitTime = waitTime

  ' Triggers delay timer. If there is active timer counting down it cancels it.
  prototype.debounce = sub ()
    m.cancel()
    m._timeoutId = setTimeout(m._callback, m._waitTime, m._context)
  end sub

  ' Cancels active debounce timer.
  prototype.cancel = sub ()
    if (m._isPending())
      clearTimeout(m._timeoutId)
      m._timeoutId = ""
    end if
  end sub

  ' @private
  prototype._isPending = function () as Boolean
    return (m._timeoutId <> "")
  end function

  return prototype
end function
