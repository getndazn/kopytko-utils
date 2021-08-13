function TestSuite__MathUtils_ceil()
  ts = MathUtilsTestSuite()
  ts.name = "MathUtils - ceil"

  ts.addTest("returns rounded up value", function (ts as Object) as String
    ' When
    actualResult = ts.__mathUtils.ceil(2.1)
    expectedResult = 3

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("returns rounded up value #2", function (ts as Object) as String
    ' When
    actualResult = ts.__mathUtils.ceil(2.001)
    expectedResult = 3

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("returns rounded up value #3", function (ts as Object) as String
    ' When
    actualResult = ts.__mathUtils.ceil(1.9)
    expectedResult = 2

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("returns casted integer", function (ts as Object) as String
    ' When
    actualResult = ts.__mathUtils.ceil(2.00000)
    expectedResult = 2

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  return ts
end function
