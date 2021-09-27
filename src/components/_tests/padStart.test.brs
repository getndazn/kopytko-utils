' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function TestSuite__padStart() as Object
  ts = KopytkoTestSuite()
  ts.name = "padStart"

  ts.addTest("returns the original value if longer than length", function (ts as Object) as String
    ' GIVEN
    value = "1234"
    length = 3
    char = "anything"
    expectedResult = value

    ' WHEN
    result = padStart(value, length, char)

    ' THEN
    return ts.assertEqual(result, expectedResult)
  end function)

  ts.addTest("returns the original value if equals to the length", function (ts as Object) as String
    ' GIVEN
    value = "1234"
    length = 4
    char = "anything"
    expectedResult = value

    ' WHEN
    result = padStart(value, length, char)

    ' THEN
    return ts.assertEqual(result, expectedResult)
  end function)

  ts.addTest("adds a char when the value is one sign shorter than length", function (ts as Object) as String
    ' GIVEN
    value = "1234"
    length = 5
    char = "0"
    expectedResult = "01234"

    ' WHEN
    result = padStart(value, length, char)

    ' THEN
    return ts.assertEqual(result, expectedResult)
  end function)

  ts.addTest("adds chars when the value is more then 1 sign shorter than length", function (ts as Object) as String
    ' GIVEN
    value = "1234"
    length = 7
    char = "0"
    expectedResult = "0001234"

    ' WHEN
    result = padStart(value, length, char)

    ' THEN
    return ts.assertEqual(result, expectedResult)
  end function)

  return ts
end function
