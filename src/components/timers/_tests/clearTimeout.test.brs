' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/timers/setTimeout.brs
function TestSuite__clearTimeout() as Object
  ts = KopytkoTestSuite()
  ts.name = "clearTimeout"

  ts.addTest("it removes the timeout from the $$setTimeoutData property when calling clearTimeout passing the timeout Id", function (ts as Object) as String
    ' Given
    timeoutId = setTimeout(sub (): end sub, 0.2)

    ' When
    clearTimeout(timeoutId)

    ' Then
    timeout = m["$$setTimeoutData"][timeoutId]

    return ts.assertInvalid(timeout, "The timeout was not cleared")
  end function)

  return ts
end function
