' Stops setTimeout callback calls.
' @param {Object} timeoutId - The ID of the timer returned by setTimeout.
sub clearTimeoutCore(timeoutId as Object)
  if (timeoutId = Invalid OR m["$$setTimeoutData"] = Invalid)
    return
  end if

  timeout = m["$$setTimeoutData"][timeoutId]

  if (timeout = Invalid)
    return
  end if

  timeout.timer.unobserveFieldScoped("fire")
  timeout.timer.control = "stop"
  m["$$setTimeoutData"].delete(timeoutId)
end sub
