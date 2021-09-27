' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function TestSuite__ternary() as Object
  ts = KopytkoTestSuite()
  ts.name = "ternary"

  ts.addTest("it returns the second passed param when the condition is truthful", function (ts as Object) as String
    ' When
    actualResult = ternary(true, 1, 2)
    expectedResult = 1

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("it returns the third passed param when the condition is falsy", function (ts as Object) as String
    ' When
    actualResult = ternary(false, 1, 2)
    expectedResult = 2

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  return ts
end function
