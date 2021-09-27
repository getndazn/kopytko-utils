' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/uuid.brs
function TestSuite__RxSubscriber() as Object
  ts = KopytkoTestSuite()
  ts.name = "RxSubscriber"

  ts.setBeforeEach(sub (ts as Object)
    m.__context = {
      nextValue: Invalid,
      errorValue: Invalid,
      isCompleted: false,
    }
    m.__handlers = {
      "next": sub (value as Dynamic)
        m.nextValue = value
      end sub,
      error: sub (error as Dynamic)
        m.errorValue = error
      end sub,
      complete: sub ()
        m.isCompleted = true
      end sub,
    }

    m.__mocks.uuid = { returnValue: "example-uuid" }
  end sub)

  ts.addTest("it sets uuid as id property", function (ts as Object) as Object
    ' When
    subscriber = RxSubscriber(m.__handlers, {})

    ' Then
    return ts.assertEqual(subscriber.id, "example-uuid")
  end function)

  ts.addTest("next calls handler in specific context", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    value = "super value"

    ' When
    subscriber.next(value)

    ' Then
    return ts.assertEqual(m.__context.nextValue, value)
  end function)

  ts.addTest("next calls handler in specific context even if previous value was triggered", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    value = "super value"
    subscriber.next("first")

    ' When
    subscriber.next(value)

    ' Then
    return ts.assertEqual(m.__context.nextValue, value)
  end function)

  ts.addTest("error calls handler in specific context", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub
    error = "error value"

    ' When
    subscriber.error(error, {})

    ' Then
    return ts.assertEqual(m.__context.errorValue, error)
  end function)

  ts.addTest("error stops values propagation", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub
    error = "error value"

    ' When
    subscriber.error(error, {})
    subscriber.next(value)

    ' Then
    return ts.assertInvalid(m.__context.nextValue)
  end function)

  ts.addTest("error unsubscribes subscriber", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    error = "error value"
    observable = {
      wasUnsubscribeCalled: false,
    }
    subscriber._unsubscribe = sub (subscriber as Object)
      m.wasUnsubscribeCalled = true
    end sub

    ' When
    subscriber.error(error, observable)

    ' Then
    return ts.assertTrue(observable.wasUnsubscribeCalled)
  end function)

  ts.addTest("complete calls handler in specific context", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub

    ' When
    subscriber.complete({})

    ' Then
    return ts.assertTrue(m.__context.isCompleted)
  end function)

  ts.addTest("complete stops values propagation", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub

    ' When
    subscriber.complete({})
    subscriber.next("any")

    ' Then
    return ts.assertInvalid(m.__context.nextValue)
  end function)

  ts.addTest("complete stops error propagation", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub

    ' When
    subscriber.complete({})
    subscriber.error("any", {})

    ' Then
    return ts.assertInvalid(m.__context.errorValue)
  end function)

  ts.addTest("complete unsubscribes subscriber", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    observable = {
      wasUnsubscribeCalled: false,
    }
    subscriber._unsubscribe = sub (subscriber as Object)
      m.wasUnsubscribeCalled = true
    end sub

    ' When
    subscriber.complete(observable)

    ' Then
    return ts.assertTrue(observable.wasUnsubscribeCalled)
  end function)

  ts.addTest("unsubscribe calls protected unsubscribe callback in passed observable context", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    observable = {
      wasUnsubscribeCalled: false,
    }
    subscriber._unsubscribe = sub (subscriber as Object)
      m.wasUnsubscribeCalled = true
    end sub

    ' When
    subscriber.unsubscribe(observable)

    ' Then
    return ts.assertTrue(observable.wasUnsubscribeCalled)
  end function)

  ts.addTest("unsubscribe stops values propagation", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub

    ' When
    subscriber.unsubscribe({})
    subscriber.next("any")

    ' Then
    return ts.assertInvalid(m.__context.nextValue)
  end function)

  ts.addTest("unsubscribe stops error propagation", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub

    ' When
    subscriber.unsubscribe({})
    subscriber.error("any", {})

    ' Then
    return ts.assertInvalid(m.__context.errorValue)
  end function)

  ts.addTest("unsubscribe stops possiblity to complete stream", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber(m.__handlers, m.__context)
    subscriber._unsubscribe = sub (subscriber as Object): end sub

    ' When
    subscriber.unsubscribe({})
    subscriber.complete({})

    ' Then
    return ts.assertFalse(m.__context.isCompleted)
  end function)

  return ts
end function
