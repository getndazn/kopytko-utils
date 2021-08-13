' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
' @import /components/timers/setInterval.brs
function TestSuite__clearInterval() as Object
  ts = KopytkoTestSuite()
  ts.name = "clearInterval"

  ts.addTest("it removes the timeout from the $$setIntervalData property when calling clearInterval passing the interval Id", function (ts as Object) as String
    ' Given
    intervalId = setInterval(sub (): end sub, 0.2)

    ' When
    clearInterval(intervalId)

    ' Then
    interval = m["$$setIntervalData"][intervalId]

    return ts.assertInvalid(interval, "The interval was not cleared")
  end function)

  return ts
end function
