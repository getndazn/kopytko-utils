' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/rokuComponents/_mocks/Event.mock.brs
function TestSuite__setTimeout() as Object
  ts = KopytkoTestSuite()
  ts.name = "setTimeout"

  ts.addTest("it creates a $$setTimeoutData property in the current component", function (ts as Object) as String
    ' Given
    m["$$setTimeoutData"] = Invalid

    ' When
    setTimeout(sub (): end sub, 0.2)

    ' Then
    return ts.assertNotInvalid(m["$$setTimeoutData"], "The property was not created")
  end function)

  ts.addTest("it returns an Id and creates an object for the timeout in the $$setTimeoutData property", function (ts as Object) as String
    ' When
    timeoutId = setTimeout(sub (): end sub, 0.2)

    ' Then
    timeout = m["$$setTimeoutData"][timeoutId]

    return ts.assertNotInvalid(timeout, "The timeout object was not created")
  end function)

  ts.addTest("it stores a reference to a timer in the $$setTimeoutData property", function (ts as Object) as String
    ' When
    timeoutId = setTimeout(sub (): end sub, 0.2)

    ' Then
    timer = m["$$setTimeoutData"][timeoutId].timer

    return ts.assertNotInvalid(timer, "The timer was not stored")
  end function)

  ts.addTest("it calls the passed callback when its timer is fired", function (ts as Object) as String
    ' Given
    m.__callbackWasCalled = false
    timeoutId = setTimeout(sub ()
      m.__callbackWasCalled = true
    end sub, 0.2)

    ' When
    setTimeout_onTimerFired(Event({ nodeId: timeoutId }))

    ' Then
    return ts.assertTrue(m.__callbackWasCalled, "The callback was not called")
  end function)

  ts.addTest("it sets the passed timeout duration to the timer", function (ts as Object) as String
    ' When
    timeoutId = setTimeout(sub (): end sub, 0.2)

    ' Then
    actualDuration = m["$$setTimeoutData"][timeoutId].timer.duration.toStr()
    expectedDuration = "0.2"

    return ts.assertEqual(actualDuration, expectedDuration, "The duration was not set properly")
  end function)

  ts.addTest("it sets the created timer to not repeat", function (ts as Object) as String
    ' When
    timeoutId = setTimeout(sub (): end sub, 0.2)

    ' Then
    actualRepeatValue = m["$$setTimeoutData"][timeoutId].timer.repeat
    expectedRepeatValue = false

    return ts.assertEqual(actualRepeatValue, expectedRepeatValue, "The repeat field was not set properly")
  end function)

  return ts
end function
