function TestSuite__NodeUtils_Main()
  ts = NodeUtilsTestSuite()
  ts.name = "NodeUtils - Main"

  ts.addTest("findChildIndexVectorByProperty returns Invalid for an empty source node", function (ts as Object) as String
    ' Given
    expectedResult = Invalid
    node = CreateObject("roSGNode", "Node")

    ' When
    actualResult = ts.__nodeUtils.findChildIndexVectorByProperty(node, "anything", "any value")

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("findChildIndexVectorByProperty returns proper index for a flat node", function (ts as Object) as String
    ' Given
    expectedResult = [1]
    valueToFind = "second"
    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createNode("first"))
    node.appendChild(__createNode(valueToFind))
    node.appendChild(__createNode("third"))

    ' When
    actualResult = ts.__nodeUtils.findChildIndexVectorByProperty(node, "id", valueToFind)

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("findChildIndexVectorByProperty returns Invalid if not found an item with given value", function (ts as Object) as String
    ' Given
    valueToFind = "magic"
    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createNode("first"))
    node.appendChild(__createNode("second"))
    node.appendChild(__createNode("third"))

    ' When
    actualResult = ts.__nodeUtils.findChildIndexVectorByProperty(node, "id", valueToFind)

    ' Then
    return ts.assertInvalid(actualResult)
  end function)

  ts.addTest("findChildIndexVectorByProperty returns proper index for a flat node with complex key", function (ts as Object) as String
    ' Given
    expectedResult = [2]
    propertyPath = "complex.key"
    valueToFind = "third"

    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createComplexNode("first"))
    node.appendChild(__createComplexNode("second"))
    node.appendChild(__createComplexNode(valueToFind))

    ' When
    actualResult = ts.__nodeUtils.findChildIndexVectorByProperty(node, propertyPath, valueToFind)

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("findChildIndexVectorByProperty returns proper index for a 2-lvl node", function (ts as Object) as String
    ' Given
    level = 2
    expectedResult = [1, 1]
    valueToFind = "second-second"
    node = CreateObject("roSGNode", "Node")

    firstChild = __createNode("first")
    firstChild.appendChild(__createNode("first-first"))
    firstChild.appendChild(__createNode("first-second"))
    node.appendChild(firstChild)

    secondChild = __createNode("second")
    secondChild.appendChild(__createNode("second-first"))
    secondChild.appendChild(__createNode("second-second"))
    node.appendChild(secondChild)

    ' When
    actualResult = ts.__nodeUtils.findChildIndexVectorByProperty(node, "id", valueToFind, level)

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("findChildIndexByProperty returns Invalid for an empty source node", function (ts as Object) as String
    ' Given
    expectedResult = Invalid
    node = CreateObject("roSGNode", "Node")

    ' When
    actualResult = ts.__nodeUtils.findChildIndexByProperty(node, "anything", "any value")

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("findChildIndexByProperty returns Invalid if not found an item with given value", function (ts as Object) as String
    ' Given
    valueToFind = "magic"
    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createNode("first"))
    node.appendChild(__createNode("second"))
    node.appendChild(__createNode("third"))

    ' When
    actualResult = ts.__nodeUtils.findChildIndexByProperty(node, "id", valueToFind)

    ' Then
    return ts.assertInvalid(actualResult)
  end function)

  ts.addTest("findChildIndexByProperty returns proper index for a node with complex key", function (ts as Object) as String
    ' Given
    expectedResult = 2
    propertyPath = "complex.key"
    valueToFind = "third"

    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createComplexNode("first"))
    node.appendChild(__createComplexNode("second"))
    node.appendChild(__createComplexNode(valueToFind))

    ' When
    actualResult = ts.__nodeUtils.findChildIndexByProperty(node, propertyPath, valueToFind)

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("findAllByProperty returns all nodes with proper property value", function (ts as Object) as String
    ' Given
    level = 2
    expectedResult = []
    valueToFind = "cool"
    node = CreateObject("roSGNode", "Node")

    firstChild = __createNode("first")
    toFind = firstChild.appendChild(__createNode("cool"))
    expectedResult.push(toFind)
    firstChild.appendChild(__createNode("first-second"))
    node.appendChild(firstChild)

    secondChild = __createNode("second")
    secondChild.appendChild(__createNode("second-first"))
    toFind = secondChild.appendChild(__createNode("cool"))
    expectedResult.push(toFind)
    node.appendChild(secondChild)

    ' When
    actualResult = ts.__nodeUtils.findAllByProperty(node, "id", valueToFind, level)

    ' Then
    return ts.assertEqual(actualResult.count(), expectedResult.count())
  end function)

  ts.addTest("getItemByIndexVector returns Invalid if node is invalid", function (ts as Object) as String
    ' Given
    indexVector = [10, 1]
    node = Invalid

    ' When
    actualResult = ts.__nodeUtils.getItemByIndexVector(node, indexVector)

    ' Then
    return ts.assertInvalid(actualResult)
  end function)

  ts.addTest("getItemByIndexVector returns Invalid if item doesn't exist", function (ts as Object) as String
    ' Given
    indexVector = [10, 1]
    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createNode("first"))
    node.appendChild(__createNode("second"))
    node.appendChild(__createNode("third"))

    ' When
    actualResult = ts.__nodeUtils.getItemByIndexVector(node, indexVector)

    ' Then
    return ts.assertInvalid(actualResult)
  end function)

  ts.addTest("getItemByIndexVector returns item - one level", function (ts as Object) as String
    ' Given
    indexVector = [1]
    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createNode("first"))
    expectedResult = __createNode("second")
    node.appendChild(expectedResult)
    node.appendChild(__createNode("third"))

    ' When
    actualResult = ts.__nodeUtils.getItemByIndexVector(node, indexVector)

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  ts.addTest("getItemByIndexVector returns item - two levels", function (ts as Object) as String
    ' Given
    indexVector = [1, 1]
    node = CreateObject("roSGNode", "Node")
    node.appendChild(__createNode("first"))

    secondChild = __createNode("second")
    secondChild.appendChild(__createNode("second-first"))
    expectedResult = __createNode("second-second")
    secondChild.appendChild(expectedResult)
    secondChild.appendChild(__createNode("second-third"))
    node.appendChild(secondChild)

    node.appendChild(__createNode("third"))

    ' When
    actualResult = ts.__nodeUtils.getItemByIndexVector(node, indexVector)

    ' Then
    return ts.assertEqual(actualResult, expectedResult)
  end function)

  return ts
end function
