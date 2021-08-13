function TestSuite__ArrayUtils_contains()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - contains"

  ts.addTest("returns true if value found", function (ts as Object) as String
    ' Given
    arrayToSearch = [1, 2, 3]
    value = 2

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, value)

    ' Then
    return ts.assertEqual(result, true)
  end function)

  ts.addTest("returns true if value found by associative array", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      {
        id: 1,
        name: "Mauricio",
      },
      {
        id: 2,
        name: "Rafalito",
      },
    ]
    predicate = { id: 2 }

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, predicate)

    ' Then
    return ts.assertEqual(result, true)
  end function)

  ts.addTest("returns true if value found by function", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      {
        id: 1,
        name: "Pablito",
      },
      {
        id: 2,
        name: "Tomaszinho",
      },
    ]
    predicate = function (item as Object) as Boolean
      return item.id = 2
    end function

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, predicate)

    ' Then
    return ts.assertEqual(result, true)
  end function)

  ts.addTest("returns false if value not found", function (ts as Object) as String
    ' Given
    arrayToSearch = [1,2,3]
    value = 666

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, value)

    ' Then
    return ts.assertEqual(result, false)
  end function)

  ts.addTest("returns false if value not found by associative array", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      {
        id: 1,
        name: "Mauricio",
      },
      {
        id: 2,
        name: "Rafalito",
      },
    ]
    predicate = { id: 3 }

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, predicate)

    ' Then
    return ts.assertEqual(result, false)
  end function)

  ts.addTest("returns false if value not found by function", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      {
        id: 1,
        name: "Pablito",
      },
      {
        id: 2,
        name: "Tomaszinho",
      },
    ]
    predicate = function (item as Object) as Boolean
      return item.id = 3
    end function

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, predicate)

    ' Then
    return ts.assertEqual(result, false)
  end function)

  ts.addTest("returns false for empty array to search", function (ts as Object) as String
    ' Given
    arrayToSearch = []
    value = 666

    ' When
    result = ts.__arrayUtils.contains(arrayToSearch, value)

    ' Then
    return ts.assertEqual(result, false)
  end function)

  return ts
end function
