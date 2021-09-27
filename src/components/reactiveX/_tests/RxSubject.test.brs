' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function TestSuite__RxSubject() as Object
  ts = KopytkoTestSuite()
  ts.name = "RxSubject"

  ts.setBeforeEach(sub (ts as Object)
    m.__context1 = {
      nextValue: Invalid,
      errorValue: Invalid,
      isCompleted: false,
    }
    m.__context2 = {
      nextValue: Invalid,
      errorValue: Invalid,
      isCompleted: false,
    }
    m.__observer = {
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

    m.__subject = RxSubject()
    m.__subject.subscribe(m.__observer, Invalid, Invalid, m.__context1)
    m.__subject.subscribe(m.__observer, Invalid, Invalid, m.__context2)

    m.__mocks.uuid = { returnValue: "example-uuid" }
  end sub)

  ts.addTest("next calls all subscribers", function (ts as Object) as Object
    ' Given
    value = "super value"

    ' When
    m.__subject.next(value)

    ' Then
    ' We can't mock RxSubscriber because checking if RxSubscriber.next was called twice wouldn't determine if it was
    ' called on two different subscribers once or on one subscriber twice
    return ts.assertEqual([m.__context1.nextValue, m.__context2.nextValue], [value, value])
  end function)

  ts.addTest("error calls all subscribers", function (ts as Object) as Object
    ' Given
    error = "super error"

    ' When
    m.__subject.error(error)

    ' Then
    return ts.assertEqual([m.__context1.errorValue, m.__context2.errorValue], [error, error])
  end function)

  ts.addTest("error stops propagation of next values", function (ts as Object) as Object
    ' Given
    error = "super error"

    ' When
    m.__subject.error(error)
    m.__subject.next("any")

    ' Then
    return ts.assertEqual([m.__context1.nextValue, m.__context2.nextValue], [Invalid, Invalid])
  end function)

  ts.addTest("complete calls all subscribers", function (ts as Object) as Object
    ' When
    m.__subject.complete()

    ' Then
    return ts.assertTrue(m.__context1.isCompleted AND m.__context2.isCompleted)
  end function)

  ts.addTest("complete stops propagation of next values", function (ts as Object) as Object
    ' When
    m.__subject.complete()
    m.__subject.next("any")

    ' Then
    return ts.assertEqual([m.__context1.nextValue, m.__context2.nextValue], [Invalid, Invalid])
  end function)

  ts.addTest("complete stops propagation of error values", function (ts as Object) as Object
    ' When
    m.__subject.complete()
    m.__subject.error("any")

    ' Then
    return ts.assertEqual([m.__context1.errorValue, m.__context2.errorValue], [Invalid, Invalid])
  end function)

  ts.addTest("unsubscribe stops propagation of next values", function (ts as Object) as Object
    ' When
    m.__subject.unsubscribe()
    m.__subject.next("any")

    ' Then
    return ts.assertEqual([m.__context1.nextValue, m.__context2.nextValue], [Invalid, Invalid])
  end function)

  ts.addTest("unsubscribe stops propagation of error values", function (ts as Object) as Object
    ' When
    m.__subject.unsubscribe()
    m.__subject.error("any")

    ' Then
    return ts.assertEqual([m.__context1.errorValue, m.__context2.errorValue], [Invalid, Invalid])
  end function)

  ts.addTest("unsubscribe stops possiblity to complete streams", function (ts as Object) as Object
    ' When
    m.__subject.unsubscribe()
    m.__subject.complete()

    ' Then
    return ts.assertFalse(m.__context1.isCompleted OR m.__context2.isCompleted)
  end function)

  ts.addTest("asObservable returns an object without possiblity to change stream's state", function (ts as Object) as Object
    ' When
    result = m.__subject.asObservable()

    ' Then
    return ts.assertEqual([result.next, result.error, result.complete], [Invalid, Invalid, Invalid])
  end function)

  ts.addTest("asObservable returns Observable connected to the Subject", function (ts as Object) as Object
    ' Given
    context = {
      nextValue: Invalid,
      errorValue: Invalid,
      isCompleted: false,
    }
    observable = m.__subject.asObservable()
    observable.subscribe(m.__observer, Invalid, Invalid, context)
    value = "another value"

    ' When
    m.__subject.next(value)

    ' Then
    return ts.assertEqual(context.nextValue, value)
  end function)

  ts.addTest("unsubscribe stops propagation of next values also in dynamically created observables", function (ts as Object) as Object
    ' Given
    context = {
      nextValue: Invalid,
      errorValue: Invalid,
      isCompleted: false,
    }
    observable = m.__subject.asObservable()
    observable.subscribe(m.__observer, Invalid, Invalid, context)

    ' When
    m.__subject.unsubscribe()
    m.__subject.next("any")

    ' Then
    return ts.assertInvalid(context.nextValue)
  end function)

  return ts
end function
