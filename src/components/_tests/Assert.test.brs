' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function TestSuite__Assert()
  ts = KopytkoTestSuite()
  ts.name = "Assert"

  ts.addTest("it returns false when values have different types", function (ts as Object) as String
    ' Given
    valueA = 2
    valueB = [1, 2]

    ' When
    isDeepEqual = Assert().deepEqual(valueA, valueB)

    ' Then
    return ts.assertFalse(isDeepEqual, "The return value is true")
  end function)

  ts.addTest("it returns true when value A is equal to value B but one is a wrapped type", function (ts as Object) as String
    ' Given
    valueA = 2
    valueB = Box(2)

    ' When
    isDeepEqual = Assert().deepEqual(valueA, valueB)

    ' Then
    return ts.assertTrue(isDeepEqual, "The return value is false")
  end function)

  ts.addTest("it returns false when value A node is different from value B node", function (ts as Object) as String
    ' Given
    valueA = CreateObject("roSGNode", "ContentNode")
    valueB = CreateObject("roSGNode", "ContentNode")

    ' When
    isDeepEqual = Assert().deepEqual(valueA, valueB)

    ' Then
    return ts.assertFalse(isDeepEqual, "The return value is true")
  end function)

  ts.addTest("it returns true when current node prop is the same as the new node prop", function (ts as Object) as String
    ' Given
    node = CreateObject("roSGNode", "ContentNode")
    valueA = node
    valueB = node

    ' When
    isDeepEqual = Assert().deepEqual(valueA, valueB)

    ' Then
    return ts.assertTrue(isDeepEqual, "The return value is false")
  end function)

  ts.addTest("it returns false when array value A has different count from array value B", function (ts as Object) as String
    ' Given
    valueA = [1, 2]
    valueB = [1, 2, 2]

    ' When
    isDeepEqual = Assert().deepEqual(valueA, valueB)

    ' Then
    return ts.assertFalse(isDeepEqual, "The return value is true")
  end function)

  ts.addTest("it returns false when array value A has different values from array value B", function (ts as Object) as String
    ' Given
    primitiveValuesA = [1, 2]
    primitiveValuesB = [1, 2, 3]

    arrayValuesA = [[1, 2], [2, 1]]
    arrayValuesB = [[3, 2], [1, 4]]

    assocArrayValuesA = [{ id: 1 }, { id: 2 }]
    assocArrayValuesB = [{ id: 2 }, { id: 4 }]

    ' When
    primitiveValuesAreDeeplyEqual = Assert().deepEqual(primitiveValuesA, primitiveValuesB)
    arrayValuesAreDeeplyEqual = Assert().deepEqual(arrayValuesA, arrayValuesB)
    assocArrayValuesAreDeeplyEqual = Assert().deepEqual(assocArrayValuesA, assocArrayValuesB)
    allAreDeeplyEqual = (primitiveValuesAreDeeplyEqual AND arrayValuesAreDeeplyEqual AND assocArrayValuesAreDeeplyEqual)

    ' Then
    return ts.assertFalse(allAreDeeplyEqual, "The return value is true")
  end function)

  ts.addTest("it returns true when array value A has the same values as array value B", function (ts as Object) as String
    ' Given
    primitiveValuesA = [1, 2]
    primitiveValuesB = [1, 2]

    arrayValuesA = [[1, 2], [2, 1]]
    arrayValuesB = [[1, 2], [2, 1]]

    assocArrayValuesA = [{ id: 1 }, { id: 2 }]
    assocArrayValuesB = [{ id: 1 }, { id: 2 }]

    ' When
    primitiveValuesAreDeeplyEqual = Assert().deepEqual(primitiveValuesA, primitiveValuesB)
    arrayValuesAreDeeplyEqual = Assert().deepEqual(arrayValuesA, arrayValuesB)
    assocArrayValuesAreDeeplyEqual = Assert().deepEqual(assocArrayValuesA, assocArrayValuesB)
    allAreDeeplyEqual = (primitiveValuesAreDeeplyEqual AND arrayValuesAreDeeplyEqual AND assocArrayValuesAreDeeplyEqual)

    ' Then
    return ts.assertTrue(allAreDeeplyEqual, "The return value is false")
  end function)

  ts.addTest("it returns false when assoc array value A has different keys count from assoc array vaule B", function (ts as Object) as String
    ' Given
    valueA = { id: "", value: "" }
    valueB = { id: "", value: "", otherValue: "" }

    ' When
    isDeepEqual = Assert().deepEqual(valueA, valueB)

    ' Then
    return ts.assertFalse(isDeepEqual, "The return value is true")
  end function)

  ts.addTest("it returns false when assoc array value A has different values from assoc array value B", function (ts as Object) as String
    ' Given
    primitiveValuesA = { id: 1 }
    primitiveValuesB = { id: 2 }

    arrayValuesA = { arr: [1, 2] }
    arrayValuesB = { arr: [3, 2] }

    assocArrayValuesA = { aa: { id: 1 } }
    assocArrayValuesB = { aa: { id: 2 } }

    ' When
    primitiveValuesAreDeeplyEqual = Assert().deepEqual(primitiveValuesA, primitiveValuesB)
    arrayValuesAreDeeplyEqual = Assert().deepEqual(arrayValuesA, arrayValuesB)
    assocArrayValuesAreDeeplyEqual = Assert().deepEqual(assocArrayValuesA, assocArrayValuesB)
    allAreDeeplyEqual = (primitiveValuesAreDeeplyEqual AND arrayValuesAreDeeplyEqual AND assocArrayValuesAreDeeplyEqual)

    ' Then
    return ts.assertFalse(allAreDeeplyEqual, "The return value is true")
  end function)

  ts.addTest("it returns true when assoc array value A has the same values as assoc array value B", function (ts as Object) as String
    ' Given
    primitiveValuesA = { id: 1 }
    primitiveValuesB = { id: 1 }

    arrayValuesA = { arr: [1, 2] }
    arrayValuesB = { arr: [1, 2] }

    assocArrayValuesA = { aa: { id: 1 } }
    assocArrayValuesB = { aa: { id: 1 } }

    ' When
    primitiveValuesAreDeeplyEqual = Assert().deepEqual(primitiveValuesA, primitiveValuesB)
    arrayValuesAreDeeplyEqual = Assert().deepEqual(arrayValuesA, arrayValuesB)
    assocArrayValuesAreDeeplyEqual = Assert().deepEqual(assocArrayValuesA, assocArrayValuesB)
    allAreDeeplyEqual = (primitiveValuesAreDeeplyEqual AND arrayValuesAreDeeplyEqual AND assocArrayValuesAreDeeplyEqual)

    ' Then
    return ts.assertTrue(allAreDeeplyEqual, "The return value is false")
  end function)

  return ts
end function
