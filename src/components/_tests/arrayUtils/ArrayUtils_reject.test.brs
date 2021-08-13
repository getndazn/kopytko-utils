function TestSuite__ArrayUtils_reject()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - reject"

  ts.addTest("it returns a new array without rejected out elements", function (ts as Object) as String
    ' Given
    arrayToReject = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedResult = [
      { id: 1, name: "item-1" },
      { id: 3, name: "item-3" },
    ]

    ' When
    result = ts.__arrayUtils.reject(arrayToReject, function (item as Object) as Object
      return item.name = "item-2"
    end function)

    ' Then
    return ts.assertEqual(expectedResult, result)
  end function)

  ts.addTest("it returns a new array without rejected out elements - assocarray as a predicate", function (ts as Object) as String
    ' Given
    arrayToReject = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedResult = [
      { id: 1, name: "item-1" },
      { id: 3, name: "item-3" },
    ]

    ' When
    result = ts.__arrayUtils.reject(arrayToReject, { name: "item-2" })

    ' Then
    return ts.assertEqual(expectedResult, result)
  end function)

  ts.addTest("it returns an empty array if always returning true in the predicate", function (ts as Object) as String
    ' Given
    arrayToReject = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedResult = []

    ' When
    result = ts.__arrayUtils.reject(arrayToReject, function (item as Object) as Object
      return true
    end function)

    ' Then
    return ts.assertEqual(expectedResult, result)
  end function)

  return ts
end function
