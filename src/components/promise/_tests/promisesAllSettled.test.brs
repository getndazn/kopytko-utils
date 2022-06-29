' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/promise/Promise.brs
' @import /components/promise/PromiseReject.brs
' @import /components/promise/PromiseResolve.brs
function TestSuite__PromisesAllSettled() as object
  ts = KopytkoTestSuite()
  ts.name = "promisesAllSettled"

  ts.setBeforeEach(sub (ts as object)
    m.__timesRejected = 0
    m.__timesResolved = 0

    m.__rejectedValue = invalid
    m.__resolvedValue = invalid
  end sub)

  ts.addTest("should return a promise", function(ts as object) as string
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    ' When
    finalPromise = promisesAllSettled([firstPromise, secondPromise])

    ' Then
    return ts.assertTrue(finalPromise.doesExist("_isPromise"))
  end function)

  ts.addTest("should be pending if not all promises have either resolved or rejected", function(ts as object) as string
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()
    thirdPromise = Promise()

    finalPromise = promisesAllSettled([firstPromise, secondPromise, thirdPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("any value")
    secondPromise.reject("rejected value")

    ' Then
    return ts.assertEqual(finalPromise.STATUS_PENDING, finalPromise.status)
  end function)

  ts.addTest("should be fulfilled if all promises have either resolved or rejected", function(ts as object) as string
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()
    thirdPromise = Promise()

    finalPromise = promisesAllSettled([firstPromise, secondPromise, thirdPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")
    secondPromise.reject("rejected value")
    thirdPromise.resolve("third value")

    ' Then
    return ts.assertEqual(finalPromise.STATUS_FULFILLED, finalPromise.status)
  end function)

  ts.addTest("should resolve an array of objects [status, value] if all promises have either resolved or rejected", function(ts as object) as string
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAllSettled([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    firstPromise.resolve("first value")
    secondPromise.reject("rejected value")

    ' Then
    return ts.assertEqual(m.__resolvedValue, [
      { status: finalPromise.STATUS_FULFILLED, value: "first value" },
      { status: finalPromise.STATUS_REJECTED, value: "rejected value" }
    ])
  end function)

  ts.addTest("should resolve an array of objects [status, value] in promises order if all promises have either resolved or rejected", function(ts as object) as string
    ' Given
    firstPromise = Promise()
    secondPromise = Promise()

    finalPromise = promisesAllSettled([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)
    secondPromise.reject("rejected value")
    firstPromise.resolve("first value")

    ' Then
    return ts.assertEqual(m.__resolvedValue, [
      { status: finalPromise.STATUS_FULFILLED, value: "first value" },
      { status: finalPromise.STATUS_REJECTED, value: "rejected value" }
    ])
  end function)

  ts.addTest("should immediately resolve an empty array of promises", function(ts as object) as string
    ' Given
    finalPromise = promisesAllSettled([])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__timesResolved, 1)
  end function)

  ts.addTest("should immediately resolve an empty array of promises with empty array as an argument", function(ts as object) as string
    ' Given
    emptyArray = []
    finalPromise = promisesAllSettled(emptyArray)

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__resolvedValue, emptyArray)
  end function)

  ts.addTest("should immediately resolve for an array of resolved or rejected promises", function(ts as object) as string
    ' Given
    firstPromise = PromiseResolve("first value")
    secondPromise = PromiseReject("rejected value")
    finalPromise = promisesAllSettled([firstPromise, secondPromise])

    ' When
    finalPromise.then(onResolve, onReject)

    ' Then
    return ts.assertEqual(m.__resolvedValue, [
      { status: finalPromise.STATUS_FULFILLED, value: "first value" },
      { status: finalPromise.STATUS_REJECTED, value: "rejected value" }
    ])
  end function)

  return ts
end function

sub onResolve(value as dynamic)
  m.__timesResolved++
  m.__resolvedValue = value
end sub

sub onReject(value as dynamic)
  m.__timesRejected++
  m.__rejectedValue = value
end sub
