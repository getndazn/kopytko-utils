function TestSuite__ArrayUtils_filter()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - filter"

  ts.addTest("it returns a new array with filtered out elements", function (ts as Object) as String
    ' Given
    arrayToFilter = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedResult = [{ id: 2, name: "item-2" }]

    ' When
    result = ts.__arrayUtils.filter(arrayToFilter, function (item as Object) as Object
      return item.name = "item-2"
    end function)

    ' Then
    return ts.assertEqual(expectedResult, result)
  end function)

  ts.addTest("it returns a new array with same elements", function (ts as Object) as String
    ' Given
    arrayToFilter = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedResult = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]

    ' When
    result = ts.__arrayUtils.filter(arrayToFilter, function (item as Object) as Object
      return true
    end function)

    ' Then
    return ts.assertEqual(expectedResult, result)
  end function)

  return ts
end function
