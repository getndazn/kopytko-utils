' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function TestSuite__getProperty() as Object
  ts = KopytkoTestSuite()
  ts.name = "getProperty"

  ts.addTest("returns default value for Invalid source", function (ts as Object) as String
    ' Given
    source = Invalid
    path = "anything"
    defaultValue = "defaultValue"

    ' When
    result = getProperty(source, path, defaultValue)

    ' Then
    return ts.assertEqual(result, defaultValue)
  end function)

  ts.addTest("returns default value for Invalid path", function (ts as Object) as String
    ' Given
    source = { super: "value" }
    path = Invalid
    defaultValue = "defaultValue"

    ' When
    result = getProperty(source, path, defaultValue)

    ' Then
    return ts.assertEqual(result, defaultValue)
  end function)

  ts.addTest("returns default value for non-existing path", function (ts as Object) as String
    ' Given
    source = { super: "value" }
    path = "nonexisting"
    defaultValue = "defaultValue"

    ' When
    result = getProperty(source, path, defaultValue)

    ' Then
    return ts.assertEqual(result, defaultValue)
  end function)

  ts.addTest("returns default value for Invalid key in path array", function (ts as Object) as String
    ' Given
    source = { super: "value" }
    path = [Invalid]
    defaultValue = "defaultValue"

    ' When
    result = getProperty(source, path, defaultValue)

    ' Then
    return ts.assertEqual(result, defaultValue)
  end function)

  ts.addTest("returns the proper value for flat source", function (ts as Object) as String
    ' Given
    expectedResult = "value"
    source = { super: "value" }
    path = "super"

    ' When
    result = getProperty(source, path)

    ' Then
    return ts.assertEqual(result, expectedResult)
  end function)

  ts.addTest("returns the proper value for multi-level source object", function (ts as Object) as String
    ' Given
    expectedResult = "value"
    source = { firstLevel: { secondLevel: { thirdLevel: "value" } } }
    path = "firstLevel.secondLevel.thirdLevel"

    ' When
    result = getProperty(source, path)

    ' Then
    return ts.assertEqual(result, expectedResult)
  end function)

  ts.addTest("returns the proper value for multi-level array of keys", function (ts as Object) as String
    ' Given
    expectedResult = "value"
    source = { firstLevel: { secondLevel: { thirdLevel: "value" } } }
    path = ["firstLevel", "secondLevel", "thirdLevel"]

    ' When
    result = getProperty(source, path)

    ' Then
    return ts.assertEqual(result, expectedResult)
  end function)

  return ts
end function
