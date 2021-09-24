' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function TestSuite__Promise() as Object
  ts = KopytkoTestSuite()
  ts.name = "Promise"

  ts.setBeforeEach(sub (ts as Object)
    m.__timesRejected = 0
    m.__timesResolved = 0
    m.__timesFinallyCalled = 0

    m.__lastRejectedValue = Invalid
    m.__lastRejectedContext = Invalid
    m.__lastResolvedValue = Invalid
    m.__lastResolvedContext = Invalid
    m.__param = 0
  end sub)

  ts.addTest("should resolve promise", function (ts as Object) as String
    ' Given
    expectedNumber = 1

    testedPromise = Promise()
    testedPromise.then(onResolve)

    ' When
    testedPromise.resolve()

    ' Then
    return ts.assertEqual(m.__timesResolved, expectedNumber)
  end function)

  ts.addTest("should resolve promise only once", function (ts as Object) as String
    ' Given
    expectedNumber = 1

    testedPromise = Promise()
    testedPromise.then(onResolve)

    ' When
    testedPromise.resolve()
    testedPromise.resolve()

    ' Then
    return ts.assertEqual(m.__timesResolved, expectedNumber)
  end function)

  ts.addTest("should reject promise", function (ts as Object) as String
    ' Given
    expectedNumber = 1

    testedPromise = Promise()
    testedPromise.then(onResolve, onReject)

    ' When
    testedPromise.reject()

    ' Then
    return ts.assertEqual(m.__timesRejected, expectedNumber)
  end function)

  ts.addTest("should reject promise only once", function (ts as Object) as String
    ' Given
    expectedNumber = 1

    testedPromise = Promise()
    testedPromise.then(onResolve, onReject)

    ' When
    testedPromise.reject()
    testedPromise.reject()

    ' Then
    return ts.assertEqual(m.__timesRejected, expectedNumber)
  end function)

  ts.addTest("should chain promise", function (ts as Object) as String
    ' Given
    expectedNumber = 3

    testedPromise = Promise()
    testedPromise.then(onResolve).then(onResolve).then(onResolve)

    ' When
    testedPromise.resolve()

    ' Then
    return ts.assertEqual(m.__timesResolved, expectedNumber)
  end function)

  ts.addTest("should pass output of promise to input of next one", function (ts as Object) as String
    ' Given
    expectedNumber = 2

    testedPromise = Promise()
    testedPromise.then(onResolvePassArgument).then(onResolvePassArgument)

    ' When
    testedPromise.resolve(0)

    ' Then
    return ts.assertEqual(m.__param, expectedNumber)
  end function)

  ts.addTest("should resolve next callback after rejecting promise", function (ts as Object) as String
    ' Given
    expectedNumber = 2

    testedPromise = Promise()
    testedPromise.then(onResolve, onReject).then(onResolve)

    ' When
    testedPromise.reject()

    ' Then
    return ts.assertEqual(m.__timesResolved + m.__timesRejected, expectedNumber)
  end function)

  ts.addTest("should catch the rejection in the .catch()", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.catch(onReject)

    ' When
    testedPromise.reject()

    ' Then
    return ts.assertEqual(m.__timesRejected, 1)
  end function)

  ts.addTest("should catch the proper value in the .catch() after rejection", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.catch(onReject)
    rejectedValue = "test"

    ' When
    testedPromise.reject(rejectedValue)

    ' Then
    return ts.assertEqual(m.__lastRejectedValue, rejectedValue)
  end function)

  ts.addTest("should skip the resolve callback and catch the rejection in the next .catch()", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.then(onResolve).catch(onReject)

    ' When
    testedPromise.reject()

    ' Then
    wasntResolved = (m.__timesResolved = 0)
    wasCaughtOnce = (m.__timesRejected = 1)

    return ts.assertTrue(wasntResolved AND wasCaughtOnce)
  end function)

  ts.addTest("should catch the resolved value in catch() in the chain", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.then(onResolve).catch(onReject)
    rejectedValue = "test"

    ' When
    testedPromise.reject(rejectedValue)

    ' Then
    return ts.assertEqual(m.__lastRejectedValue, rejectedValue)
  end function)

  ts.addTest("should resolve the callback after the catch in .catch()", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.catch(onReject).then(onResolve)

    ' When
    testedPromise.reject()

    ' Then
    return ts.assertEqual(m.__timesResolved, 1)
  end function)

  ts.addTest("should execute the finally callback after resolving the chain", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.then(onResolve).then(onResolve).finally(onFinally)

    ' When
    testedPromise.resolve(true)

    ' Then
    return ts.assertEqual(m.__timesFinallyCalled, 1)
  end function)

  ts.addTest("should execute the finally callback after rejecting the chain", function (ts as Object) as String
    ' Given
    testedPromise = Promise()
    testedPromise.then(onResolve, onReject).then(onResolve).finally(onFinally)

    ' When
    testedPromise.reject(true)

    ' Then
    return ts.assertEqual(m.__timesFinallyCalled, 1)
  end function)

  ts.addTest("should pass proper context", function (ts as Object) as String
    ' Given
    contextName = "testName"
    context = { contextName: contextName }

    testedPromise = Promise()
    testedPromise.then(onResolveWithContext, Invalid, context)

    ' When
    testedPromise.resolve()

    ' Then
    return ts.assertEqual(m.__lastResolvedContext.contextName, contextName)
  end function)

  return ts
end function

sub onResolve(value as Dynamic)
  m.__timesResolved++
  m.__lastResolvedValue = value
end sub

sub onResolveWithContext(value as Dynamic, context as Object)
  m.__timesResolved++
  m.__lastResolvedValue = value
  m.__lastResolvedContext = context
end sub

sub onReject(value as Dynamic)
  m.__timesRejected++
  m.__lastRejectedValue = value
end sub

sub onRejectWithContext(value as Dynamic, context as Object)
  m.__timesRejected++
  m.__lastRejectedValue = value
  m.__lastRejectedContext = context
end sub

sub onFinally(arg1 = Invalid as Dynamic)
  m.__timesFinallyCalled++
end sub

function onResolvePassArgument(param as Integer) as Integer
  m.__param = param + 1

  return m.__param
end function
