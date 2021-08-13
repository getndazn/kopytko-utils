function TestSuite__ArrayUtils_sortBy()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - sortBy"

  ts.addTest("it sorts the array using given function", function (ts as Object) as String
    ' Given
    array = [
      { id: 3, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 1, name: "item-3" },
    ]

    ' When
    actualArray = ts.__arrayUtils.sortBy(array, function (item as Object) as Object
      return item.id
    end function)

    ' Then
    expectedArray = [
      { id: 1, name: "item-3" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-1" },
    ]

    return ts.assertEqual(expectedArray, actualArray)
  end function)

  ts.addTest("it keeps order of items with the same sort value", function (ts as Object) as String
    ' Given
    array = [
      { id: 3, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 2, name: "item-3" },
    ]

    ' When
    actualArray = ts.__arrayUtils.sortBy(array, function (item as Object) as Object
      return item.id
    end function)

    ' Then
    expectedArray = [
      { id: 2, name: "item-2" },
      { id: 2, name: "item-3" },
      { id: 3, name: "item-1" },
    ]

    return ts.assertEqual(expectedArray, actualArray)
  end function)

  return ts
end function
