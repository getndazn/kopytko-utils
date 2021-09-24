' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/reactiveX/RxSubscriber.brs
' @mock /components/reactiveX/RxSubscription.brs
function TestSuite__RxObservable() as Object
  ts = KopytkoTestSuite()
  ts.name = "RxObservable"

  ts.setBeforeEach(sub (ts as Object)
    m.__emptySub = sub ()
    end sub
    m.__exampleObserver = { "next": "observer.next", error: "observer.error", complete: "observer.complete" }
    m.__subscribe = sub (subscriber as Object, data as Object)
    end sub
  end sub)

  ts.addTest("subscribe returns Invalid if wrong observerOrNext parameter passed", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)

    ' When
    result = observable.subscribe(Invalid)

    ' Then
    return ts.assertInvalid(result)
  end function)

  ts.addTest("subscribe creates RxSubscriber with passed observer's handlers", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)

    ' When
    observable.subscribe(m.__exampleObserver)

    ' Then
    subscriberConstructorCalls = m.__mocks.RxSubscriber.constructorCalls
    if (subscriberConstructorCalls.count() <> 1)
      return ts.fail("RxSubscriber was created " + subscriberConstructorCalls.count().toStr() + " times")
    end if

    return ts.assertEqual(subscriberConstructorCalls[0].params, { handlers: m.__exampleObserver, context: Invalid })
  end function)

  ts.addTest("subscribe creates RxSubscriber with passed observer's handlers and context", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)
    context = { super: "context" }

    ' When
    observable.subscribe(m.__exampleObserver, Invalid, Invalid, context)

    ' Then
    subscriberConstructorCalls = m.__mocks.RxSubscriber.constructorCalls
    if (subscriberConstructorCalls.count() <> 1)
      return ts.fail("RxSubscriber was created " + subscriberConstructorCalls.count().toStr() + " times")
    end if

    return ts.assertEqual(subscriberConstructorCalls[0].params, { handlers: m.__exampleObserver, context: context })
  end function)

  ts.addTest("subscribe creates RxSubscriber with passed next handler", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)

    ' When
    observable.subscribe(m.__emptySub)

    ' Then
    subscriberConstructorCalls = m.__mocks.RxSubscriber.constructorCalls
    if (subscriberConstructorCalls.count() <> 1)
      return ts.fail("RxSubscriber was created " + subscriberConstructorCalls.count().toStr() + " times")
    end if

    expectedHandlers = {
      "next": m.__emptySub,
      error: Invalid,
      complete: Invalid,
    }

    return ts.assertEqual(subscriberConstructorCalls[0].params, { handlers: expectedHandlers, context: Invalid })
  end function)

  ts.addTest("subscribe creates RxSubscriber with passed next handler and context", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)
    context = { super: "context" }

    ' When
    observable.subscribe(m.__emptySub, Invalid, Invalid, context)

    ' Then
    subscriberConstructorCalls = m.__mocks.RxSubscriber.constructorCalls
    if (subscriberConstructorCalls.count() <> 1)
      return ts.fail("RxSubscriber was created " + subscriberConstructorCalls.count().toStr() + " times")
    end if

    expectedHandlers = {
      "next": m.__emptySub,
      error: Invalid,
      complete: Invalid,
    }

    return ts.assertEqual(subscriberConstructorCalls[0].params, { handlers: expectedHandlers, context: context })
  end function)

  ts.addTest("subscribe creates RxSubscriber with passed handlers and context", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)
    context = { super: "context" }

    ' When
    observable.subscribe(m.__emptySub, m.__emptySub, m.__emptySub, context)

    ' Then
    subscriberConstructorCalls = m.__mocks.RxSubscriber.constructorCalls
    if (subscriberConstructorCalls.count() <> 1)
      return ts.fail("RxSubscriber was created " + subscriberConstructorCalls.count().toStr() + " times")
    end if

    expectedHandlers = {
      "next": m.__emptySub,
      error: m.__emptySub,
      complete: m.__emptySub,
    }

    return ts.assertEqual(subscriberConstructorCalls[0].params, { handlers: expectedHandlers, context: context })
  end function)

  ts.addTest("subscribe sets executed observable's subscribe function as _unsubscribe of created subscriber", function (ts as Object) as Object
    ' Given
    subscriberId = "example-id"
    data = { example: "data" }
    m.__mocks.RxSubscriber = { properties: { id: subscriberId } }
    subscribe = function (subscriber as Object, data as Object)
      return { subscriberId: subscriber.id, data: data }
    end function
    observable = RxObservable(subscribe, data)

    ' When
    observable.subscribe(m.__exampleObserver)

    ' Then
    subscriber = m.__mocks.RxSubscriber.instance

    return ts.assertEqual(subscriber._unsubscribe, { subscriberId: subscriberId, data: data })
  end function)

  ts.addTest("subscribe creates and returns RxSubscription", function (ts as Object) as Object
    ' Given
    observable = RxObservable(m.__subscribe)
    m.__mocks.RxSubscriber = {
      properties: { __testProp: "RxSubscriber" },
    }
    m.__mocks.RxSubscription = {
      properties: { __testProp: "RxSubscription" },
    }

    ' When
    result = observable.subscribe(m.__exampleObserver)

    ' Then
    subscriptionConstructorCalls = m.__mocks.RxSubscription.constructorCalls
    if (subscriptionConstructorCalls.count() <> 1)
      return ts.fail("RxSubscription was created " + subscriptionConstructorCalls.count().toStr() + " times")
    end if

    if (NOT ts.isMatch(subscriptionConstructorCalls[0].params, { subscriber: { __testProp: "RxSubscriber" }, observable: observable }))
      return ts.fail("Wrong parameters of RxSubscription constructor")
    end if

    return ts.assertEqual(result.__testProp, "RxSubscription")
  end function)

  return ts
end function
