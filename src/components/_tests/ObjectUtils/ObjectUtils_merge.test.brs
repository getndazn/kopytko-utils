function TestSuite__ObjectUtils_merge()
  ts = ObjectUtilsTestSuite()
  ts.name = "ObjectUtils - merge"

  ts.addTest("it returns Invalid if given object is not associative array", function (ts as Object) as String
    ' Given
    source = {
      prop1: "value1",
    }

    ' When
    result = ts.__objectUtils.merge(Invalid, source)

    ' Then
    expected = Invalid
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it returns given object if source object is Invalid", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "value1",
    }

    ' When
    result = ts.__objectUtils.merge(obj, Invalid)

    ' Then
    expected = obj
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it returns given object if source object is an array", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "value1",
    }

    ' When
    result = ts.__objectUtils.merge(obj, [1])

    ' Then
    expected = obj
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it returns given object if all source objects are Invalid", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "value1",
    }

    ' When
    result = ts.__objectUtils.merge(obj, [Invalid, Invalid])

    ' Then
    expected = obj
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it merges items of given object with source object", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "value1",
    }
    source = {
      prop2: "value2",
    }

    ' When
    result = ts.__objectUtils.merge(obj, source)

    ' Then
    expected = {
      prop1: "value1",
      prop2: "value2",
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it merges nested associative array of given object and source object", function (ts as Object) as String
    ' Given
    obj = {
      nested: {
        prop1: "value1",
      },
    }
    source = {
      nested: {
        prop2: "value2",
      },
    }

    ' When
    result = ts.__objectUtils.merge(obj, source)

    ' Then
    expected = {
      nested: {
        prop1: "value1",
        prop2: "value2",
      },
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it merges item with the same keys using value of source object", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "value1",
    }
    source = {
      prop1: "value2",
    }

    ' When
    result = ts.__objectUtils.merge(obj, source)

    ' Then
    expected = {
      prop1: "value2",
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it merges arrays if item is an array in given and source object", function (ts as Object) as String
    ' Given
    obj = {
      arr: [1, 2, 3],
    }
    source = {
      arr: [4, 5, 6],
    }

    ' When
    result = ts.__objectUtils.merge(obj, source)

    ' Then
    expected = {
      arr: [1, 2, 3, 4, 5, 6],
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  ts.addTest("it merges multiple source objects with given object", function (ts as Object) as String
    ' Given
    obj = {
      prop1: "value1",
    }
    source1 = {
      prop2: "value2",
    }
    source2 = {
      prop3: "value3",
    }

    ' When
    result = ts.__objectUtils.merge(obj, [source1, source2])

    ' Then
    expected = {
      prop1: "value1",
      prop2: "value2",
      prop3: "value3",
    }
    actual = result

    return ts.assertEqual(actual, expected)
  end function)

  return ts
end function
