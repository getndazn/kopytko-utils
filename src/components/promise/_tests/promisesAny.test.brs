' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/promise/Promise.brs
' @import /components/promise/PromiseReject.brs
' @import /components/promise/PromiseResolve.brs
function TestSuite__PromisesAny() as Object
  ts = KopytkoTestSuite()
  ts.name = "promisesAny"

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
    finalPromise = promisesAny([firstPromise, secondPromise])

    ' Then
    return ts.assertTrue(finalPromise.doesExist("_isPromise"))
  end function)

  ts.addTest("should be pending if not all promises are rejected", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.reject("error")

    ' Then
    return ts.assertEqual(finalPromise.STATUS_PENDING, finalPromise.status)
  end function)

  ts.addTest("should be fulfilled if any promise is resolved", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")

    ' Then
    return ts.assertEqual(finalPromise.STATUS_FULFILLED, finalPromise.status)
  end function)

  ts.addTest("should return first resolved promise value in final promise", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    secondPromise.resolve("value")

    ' Then
    return ts.assertEqual(m.__resolvedValue, "value")
  end function)

  ts.addTest("should return an array of errors of rejected promises in final promise", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.reject("first error")
    secondPromise.reject("second error")

    ' Then
    return ts.assertEqual(m.__rejectedValue, ["first error", "second error"])
  end function)

  ts.addTest("should return an array of errors in promises order in final promise", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    secondPromise.reject("second error")
    firstPromise.reject("first error")

    ' Then
    return ts.assertEqual(m.__rejectedValue, ["first error", "second error"])
  end function)

  ts.addTest("should ignore previously rejected promises once next is resolved", function (ts as Object) as String
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")
    secondPromise.reject("rejected value")

    ' Then
    return ts.assertEqual(m.__resolvedValue, "first value")
  end function)

  ts.addTest("should immediately rejects for an empty array of promises", function (ts as Object) as String
    ' Given
    finalPromise = promisesAny([])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__timesRejected, 1)
  end function)

  ts.addTest("should immediately rejects for an array of rejected promises", function (ts as Object) as String
    ' Given
    firstPromise = PromiseReject("first value")
    secondPromise = PromiseReject("second value")
    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__rejectedValue, ["first value", "second value"])
  end function)

  ts.addTest("should immediately resolves for already resolved promise", function (ts as Object) as String
    ' Given
    firstPromise = PromiseResolve("first value")
    secondPromise = PromiseReject("second value")
    finalPromise = promisesAny([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__resolvedValue, "first value")
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
