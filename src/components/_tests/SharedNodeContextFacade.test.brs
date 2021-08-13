' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function TestSuite__SharedNodeContextFacade() as Object
  ts = KopytkoTestSuite()
  ts.name = "SharedNodeContextFacade"

  ts.setBeforeEach(sub (ts as Object)
    m._sharedNodeContext = Invalid
    ' #orderMatters
    m.__sharedContext = SharedNodeContextFacade()
  end sub)

  ts.addTest("set - should write a given value under a given key in the shared context object", function (ts as Object) as String
    ' Given
    key = "test_context_key"
    expectedResult = "expected"

    ' When
    m.__sharedContext.set(key, expectedResult)

    ' Then
    return ts.assertEqual(m._sharedNodeContext[key], expectedResult)
  end function)

  ts.addTest("get - should read a given key from the shared context object", function (ts as Object) as String
    ' Given
    key = "test_context_key"
    expectedResult = "expected"
    m._sharedNodeContext = {}
    m._sharedNodeContext[key] = expectedResult

    ' When
    givenResult = m.__sharedContext.get(key)

    ' Then
    return ts.assertEqual(givenResult, expectedResult)
  end function)

  ts.addTest("clear - should write an Invalid under a given key in the shared context object", function (ts as Object) as String
    ' Given
    key = "test_context_key"
    m._sharedNodeContext = {}
    m._sharedNodeContext[key] = "expected"

    ' When
    m.__sharedContext.clear(key)

    ' Then
    return ts.assertInvalid(m._sharedNodeContext[key])
  end function)

  return ts
end function
