' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
' @mock /components/rokuComponents/GlobalNode.brs
' @mock /components/timers/clearTimeout.brs
' @mock /components/timers/setTimeout.brs
function TestSuite__Debouncer() as Object
  ts = KopytkoTestSuite()
  ts.name = "Debouncer"

  ts.setBeforeEach(sub (ts as Object)
    m.__mocks = {}
    m.__mocks.setTimeout = {
      calls: [],
      getReturnValue: sub (params as Object, m as Object):
        callback = m.__mocks.setTimeout.calls[m.__mocks.setTimeout.calls.count() - 1].params.callback
        callback()
      end sub,
    }
    m.__mocks.clearTimeout = {
      calls: [],
    }
    m.__mocks.debouncedFunc = {
      calls: 0,
    }
  end sub)

  ts.addTest("it fires callback function as planned", function(ts as Object) as String
    ' Given
    debounced = Debouncer(_onDebounceFired, 1)

    ' When
    debounced.debounce()

    ' Then
    return ts.assertEqual(m.__mocks.debouncedFunc.calls, 1)
  end function)

  ts.addTest("it postpones function execution", function(ts as Object) as String
    ' Given
    debounced = Debouncer(_onDebounceFired, 1)
    debounced.debounce()

    ' When
    debounced.debounce()

    ' Then
    return ts.assertMethodWasCalled("clearTimeout", {}, { times: 1 })
  end function)

  ts.addTest("it cancels function execution", function(ts as Object) as String
    ' Given
    debounced = Debouncer(_onDebounceFired, 1)
    debounced.debounce()

    ' When
    debounced.cancel()

    ' Then
    return ts.assertMethodWasCalled("clearTimeout", {}, { times: 1 })
  end function)

  ts.addTest("it should not cancel function execution more than once", function(ts as Object) as String
    ' Given
    debounced = Debouncer(_onDebounceFired, 1)
    debounced.debounce()

    ' When
    debounced.cancel()
    debounced.cancel()

    ' Then
    return ts.assertMethodWasCalled("clearTimeout", {}, { times: 1 })
  end function)

  return ts
end function

sub _onDebounceFired()
  m.__mocks.debouncedFunc.calls += 1
end sub
