function TestSuite__ArrayUtils_map()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - map"

  ts.addTest("it returns a new array with the correct items mapped", function (ts as Object) as String
    ' Given
    arrayToMap = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedResult = ["item-1", "item-2", "item-3"]

    ' When
    result = ts.__arrayUtils.map(arrayToMap, function (item as Object) as Object
      return item.name
    end function)

    ' Then
    return ts.assertEqual(result, expectedResult, "The result array is not mapped as expected")
  end function)

  ts.addTest("it returns a new array with the correct items mapped when passing scoped data as param", function (ts as Object) as String
    ' Given
    arrayToMap = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    scopedData = "item-2"
    expectedResult = ["item-1", "same name", "item-3"]

    ' When
    result = ts.__arrayUtils.map(arrayToMap, function (item as Object, name) as Object
      if (item.name <> name)
        return item.name
      end if

      return "same name"
    end function, scopedData)

    ' Then
    return ts.assertEqual(result, expectedResult, "The result array is not mapped as expected")
  end function)

  ts.addTest("it returns a new array with the items mapped using their property", function (ts as Object) as String
    ' Given
    arrayToMap = [
      { data: { id: 1, name: "item-1" } },
      { data: { id: 2, name: "item-2" } },
      { data: { id: 3, name: "item-3" } },
    ]
    expectedResult = ["item-1", "item-2", "item-3"]

    ' When
    result = ts.__arrayUtils.map(arrayToMap, "data.name")

    ' Then
    return ts.assertEqual(result, expectedResult, "The result array is not mapped as expected")
  end function)

  return ts
end function
