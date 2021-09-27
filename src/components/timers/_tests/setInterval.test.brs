' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/rokuComponents/_mocks/Event.mock.brs
' @import /components/timers/clearInterval.brs
function TestSuite__setInterval() as Object
  ts = KopytkoTestSuite()
  ts.name = "setInterval"

  ts.addTest("it creates a $$setIntervalData property in the current component", function (ts as Object) as String
    ' Given
    m["$$setIntervalData"] = Invalid

    ' When
    setInterval(sub (): end sub, 0.2)

    ' Then
    return ts.assertNotInvalid(m["$$setIntervalData"], "The property was not created")
  end function)

  ts.addTest("it returns an ID and creates an object for the interval in the $$setIntervalData property", function (ts as Object) as String
    ' When
    intervalId = setInterval(sub (): end sub, 0.2)

    ' Then
    interval = m["$$setIntervalData"][intervalId]

    return ts.assertNotInvalid(interval, "The interval object was not created")
  end function)

  ts.addTest("it stores a reference to a timer in the $$setIntervalData property", function (ts as Object) as String
    ' When
    intervalId = setInterval(sub (): end sub, 0.2)

    ' Then
    timer = m["$$setIntervalData"][intervalId].timer

    return ts.assertNotInvalid(timer, "The timer was not stored")
  end function)

  ts.addTest("it calls the passed callback when its timer is fired", function (ts as Object) as String
    ' Given
    m.__callbackWasCalled = false
    intervalId = setInterval(sub ()
      m.__callbackWasCalled = true
    end sub, 0.2)

    ' When
    setInterval_onTimerFired(Event({ nodeId: intervalId }))

    ' Then
    return ts.assertTrue(m.__callbackWasCalled, "The callback was not called")
  end function)

  ts.addTest("it sets the passed interval duration to the timer", function (ts as Object) as String
    ' When
    intervalId = setInterval(sub (): end sub, 0.2)

    ' Then
    actualDuration = m["$$setIntervalData"][intervalId].timer.duration.toStr()
    expectedDuration = "0.2"

    return ts.assertEqual(actualDuration, expectedDuration, "The duration was not set properly")
  end function)

  ts.addTest("it sets the created timer to repeat", function (ts as Object) as String
    ' When
    intervalId = setInterval(sub (): end sub, 0.2)

    ' Then
    actualRepeatValue = m["$$setIntervalData"][intervalId].timer.repeat
    expectedRepeatValue = true

    return ts.assertEqual(actualRepeatValue, expectedRepeatValue, "The duration was not set properly")
  end function)

  return ts
end function
