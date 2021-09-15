' Stops setInterval callback calls.
' @param {String|Invalid} intervalId - The ID of the timer returned by setInterval.
sub clearInterval(intervalId as Dynamic)
  if (intervalId = Invalid)
    return
  end if

  interval = m["$$setIntervalData"][intervalId]

  if (interval = Invalid)
    return
  end if

  interval.timer.unobserveFieldScoped("fire")
  interval.timer.control = "stop"
  m["$$setIntervalData"].delete(intervalId)
end sub
