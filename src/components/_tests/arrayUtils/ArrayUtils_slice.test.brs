function TestSuite__ArrayUtils_slice()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - slice"

  ts.addTest("returns all items for 0 startIndex and no endIndex", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = [1, 2, 3, 4, 5]

    ' When
    result = ts.__arrayUtils.slice(array, 0)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  ts.addTest("returns last item for last index as startIndex and no endIndex", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = [5]

    ' When
    result = ts.__arrayUtils.slice(array, 4)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  ts.addTest("returns first item for first index as startIndex and 1 endIndex", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = [1]

    ' When
    result = ts.__arrayUtils.slice(array, 0, 1)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  ts.addTest("returns first 3 items for first index as startIndex and 3 endIndex", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = [1, 2, 3]

    ' When
    result = ts.__arrayUtils.slice(array, 0, 3)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  ts.addTest("returns middle 3 items for second element as startIndex and 4 as endIndex", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = [2, 3, 4]

    ' When
    result = ts.__arrayUtils.slice(array, 1, 4)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  ts.addTest("returns an empty array for beginIndex higher than last index", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = []

    ' When
    result = ts.__arrayUtils.slice(array, 5)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  ts.addTest("sets endIndex as array length if endIndex bigger than array length", function (ts as Object) as String
    ' Given
    array = [1, 2, 3, 4, 5]
    expected = [3, 4, 5]

    ' When
    result = ts.__arrayUtils.slice(array, 2, 7)

    ' Then
    return ts.assertEqual(result, expected)
  end function)

  return ts
end function
