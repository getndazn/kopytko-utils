function TestSuite__MathUtils_toRadians()
  ts = MathUtilsTestSuite()
  ts.name = "MathUtils - toRadians"

  ts.addTest("it returns the passed degrees in radians", function (ts as Object) as String
    ' When
    actualResult = ts.__mathUtils.toRadians(180)
    expectedResult = 3.14

    ' Then
    return ts.assertEqual(actualResult, expectedResult, "The result is incorrect")
  end function)

  return ts
end function
