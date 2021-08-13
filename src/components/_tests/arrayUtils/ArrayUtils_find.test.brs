function TestSuite__ArrayUtils_find()
  ts = ArrayUtilsTestSuite()
  ts.name = "ArrayUtils - find"

  ts.addTest("it returns the correct searched item", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    expectedItem = { id: 2, name: "item-2" }

    ' When
    itemFound = ts.__arrayUtils.find(arrayToSearch, function (item as Object) as Object
      return (item.id = 2)
    end function)

    ' Then
    return ts.assertEqual(itemFound, expectedItem, "The found item is different from expected")
  end function)

  ts.addTest("it returns the correct searched item when passing scoped data as param", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]
    idToSearch = 2
    expectedItem = { id: 2, name: "item-2" }

    ' When
    itemFound = ts.__arrayUtils.find(arrayToSearch, function (item as Object, id as Integer) as Object
      return (item.id = id)
    end function, idToSearch)

    ' Then
    return ts.assertEqual(itemFound, expectedItem, "The found item is different from expected")
  end function)

  ts.addTest("it returns invalid if the item was not found", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      { id: 1, name: "item-1" },
      { id: 2, name: "item-2" },
      { id: 3, name: "item-3" },
    ]

    ' When
    itemFound = ts.__arrayUtils.find(arrayToSearch, function (item as Object) as Object
      return (item.id = 10)
    end function)

    ' Then
    return ts.assertEqual(itemFound, Invalid, "The found item is different from expected")
  end function)

  ts.addTest("it returns the first object that has the same passed object properties", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      { id: 1, name: "same-text", randomProp: 100, },
      { id: 2, name: "same-text", randomProp: 200 },
      { id: 3, name: "same-text", randomProp: 300 },
    ]

    ' When
    actualObject = ts.__arrayUtils.find(arrayToSearch, { id: 2, name: "same-text" })
    expectedObject = { id: 2, name: "same-text", randomProp: 200 }

    ' Then
    return ts.assertEqual(actualObject, expectedObject, "The found item is different from expected")
  end function)

  ts.addTest("it returns Invalid if the passed object doesn't match any object in the passed list independent of order", function (ts as Object) as String
    ' Given
    arrayToSearch = [
      { id: 1, name: "same-text", randomProp: 100, },
      { id: 2, name: "same-text", randomProp: 200 },
      { id: 3, name: "same-text", randomProp: 300 },
    ]

    ' When
    order1 = ts.__arrayUtils.find(arrayToSearch, { id: 1, name: "same" })
    order2 = ts.__arrayUtils.find(arrayToSearch, { id: 40, name: "same-text" })

    ' Then
    return ts.assertTrue(order1 = Invalid AND order2 = Invalid, "The found item is different from expected")
  end function)

  ts.addTest("it returns the first element that equals passed intrinsic type param", function (ts as Object) as String
    ' Given
    arrayToSearch = ["first", "second", "third"]

    ' When
    actualElement = ts.__arrayUtils.find(arrayToSearch, "second")
    expectedElement = "second"

    ' Then
    return ts.assertEqual(expectedElement, actualElement)
  end function)

  ts.addTest("it returns Invalid if type of passed intrinsic param is different than item type", function (ts as Object) as String
    ' Given
    arrayToSearch = ["first", "second", "third"]

    ' When
    actualElement = ts.__arrayUtils.find(arrayToSearch, 2)
    expectedElement = Invalid

    ' Then
    return ts.assertEqual(expectedElement, actualElement)
  end function)

  return ts
end function
