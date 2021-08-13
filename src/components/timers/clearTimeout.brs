' @import /components/timers/clearTimeoutCore.brs

' Stops setTimeout callback calls.
' Wrapper function for clearTimeoutCore. Main purpose is to make mocking clearTimeout in the tests easier.
' @param {Object} timeoutId - The ID of the timer returned by setTimeout.
sub clearTimeout(timeoutId as Object)
  clearTimeoutCore(timeoutId)
end sub
