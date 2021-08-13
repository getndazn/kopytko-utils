function TestSuite__ObjectUtils_invert()
  ts = ObjectUtilsTestSuite()
  ts.name = "ObjectUtils - invert"

  ts.addTest("it returns an inverted key-value object", function (ts as Object) as String
    ' Given
    obj = {
      "PROP1": "1",
      prop2: 2,
      PROP3: true,
    }

    ' When
    result = ts.__objectUtils.invert(obj)

    ' Then
    expected = {
      "1": "PROP1",
      "2": "prop2",
      "true": "prop3",
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it ignores non-castable to string values", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "1",
      prop2: [4],
      prop3: { test: "t" },
      prop4: 4,
    }

    ' When
    result = ts.__objectUtils.invert(obj)

    ' Then
    expected = {
      "1": "prop1",
      "4": "prop4",
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it overwrites value if nonunique", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "1",
      prop2: "2",
      prop3: "1",
    }

    ' When
    result = ts.__objectUtils.invert(obj)

    ' Then
    expected = {
      "1": "prop3",
      "2": "prop2",
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  return ts
end function
