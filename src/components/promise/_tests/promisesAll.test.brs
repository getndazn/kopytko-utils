' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
' @import /components/promise/Promise.brs
' @import /components/promise/PromiseReject.brs
' @import /components/promise/PromiseResolve.brs
function TestSuite__PromisesAll() as Object
  ts = KopytkoTestSuite()
  ts.name = "promisesAll"

  ts.setBeforeEach(sub (ts as Object)
    m.__timesRejected = 0
    m.__timesResolved = 0

    m.__rejectedValue = Invalid
    m.__resolvedValue = Invalid
  end sub)

  ts.addTest("should return a promise", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    ' When
    finalPromise = promisesAll([firstPromise, secondPromise])

    ' Then
    return ts.assertTrue(finalPromise.doesExist("_isPromise"))
  end function)

  ts.addTest("should be pending if not all promises are resolved", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("any value")

    ' Then
    return ts.assertEqual(finalPromise.STATUS_PENDING, finalPromise.status)
  end function)

  ts.addTest("should be fulfilled if all promises are resolved", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")
    secondPromise.resolve("second value")

    ' Then
    return ts.assertEqual(finalPromise.STATUS_FULFILLED, finalPromise.status)
  end function)

  ts.addTest("should resolve an array of values if all promises are resolved", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")
    secondPromise.resolve("second value")

    ' Then
    return ts.assertEqual(m.__resolvedValue, ["first value", "second value"])
  end function)

  ts.addTest("should resolve an array of values in promises order if all promises are resolved", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    secondPromise.resolve("second value")
    firstPromise.resolve("first value")

    ' Then
    return ts.assertEqual(m.__resolvedValue, ["first value", "second value"])
  end function)

  ts.addTest("should be 'fail-fast'", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.reject("rejected value")

    ' Then
    return ts.assertEqual(m.__rejectedValue, "rejected value")
  end function)

  ts.addTest("should ignore previously resolved promises once next is rejected", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")
    secondPromise.reject("rejected value")

    ' Then
    return ts.assertEqual(m.__rejectedValue, "rejected value")
  end function)

  ts.addTest("should immediately resolve an empty array of promises", function (ts as Object) as String
    ' Given
    finalPromise = promisesAll([])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__timesResolved, 1)
  end function)

  ts.addTest("should immediately resolve an empty array of promises with empty array as an argument", function (ts as Object) as String
    ' Given
    emptyArray = []
    finalPromise = promisesAll(emptyArray)

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__resolvedValue, emptyArray)
  end function)

  ts.addTest("should immediately resolve for an array of resolved promises", function (ts as Object) as String
    ' Given
    firstPromise = PromiseResolve("first value")
    secondPromise = PromiseResolve("second value")
    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__resolvedValue, ["first value", "second value"])
  end function)

  ts.addTest("should immediately reject for already rejected promise", function (ts as Object) as String
    ' Given
    firstPromise = PromiseResolve("first value")
    secondPromise = PromiseReject("second value")
    finalPromise = promisesAll([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__rejectedValue, "second value")
  end function)

  return ts
end function

sub onResolve(value as Dynamic)
  m.__timesResolved++
  m.__resolvedValue = value
end sub

sub onReject(value as Dynamic)
  m.__timesRejected++
  m.__rejectedValue = value
end sub
