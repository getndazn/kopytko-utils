' @import /components/timers/setTimeoutCore.brs

' Executes given callback after given timeout.
' Wrapper funcion for setTimeoutCore. Main purpose is to make mocking setTimeout in the tests easier.
' @param {Function} callback - Function that is fired.
' @param {Float} timeout - Measured in seconds.
' @param {Object} [context=Invalid] - Additional scope of execution.
' @returns {String} - ID of the timer.
function setTimeout(callback as Function, timeout as Float, context = Invalid as Object) as String
  return setTimeoutCore(callback, timeout, context)
end function
