function TestSuite__NodeUtils_areNodesTheSame()
  ts = NodeUtilsTestSuite()
  ts.name = "NodeUtils - areNodesTheSame"

  ts.addTest("it returns false for two different instances of nodes", function (ts as Object) as String
    ' Given
    node1 = __createNode("node1")
    node2 = __createNode("node2")

    ' When
    actualResult = ts.__nodeUtils.areNodesTheSame(node1, node2)

    ' Then
    return ts.assertFalse(actualResult)
  end function)

  ts.addTest("it returns true for the same instances of nodes", function (ts as Object) as String
    ' Given
    node1 = __createNode("node1")
    node2 = node1

    ' When
    actualResult = ts.__nodeUtils.areNodesTheSame(node1, node2)

    ' Then
    return ts.assertTrue(actualResult)
  end function)

  ts.addTest("it returns false if only first node is Invalid", function (ts as Object) as String
    ' Given
    node1 = Invalid
    node2 = __createNode("node1")

    ' When
    actualResult = ts.__nodeUtils.areNodesTheSame(node1, node2)

    ' Then
    return ts.assertFalse(actualResult)
  end function)

  ts.addTest("it returns false if only second node is Invalid", function (ts as Object) as String
    ' Given
    node1 = __createNode("node1")
    node2 = Invalid

    ' When
    actualResult = ts.__nodeUtils.areNodesTheSame(node1, node2)

    ' Then
    return ts.assertFalse(actualResult)
  end function)

  ts.addTest("it returns true if both nodes are Invalid", function (ts as Object) as String
    ' Given
    node1 = Invalid
    node2 = Invalid

    ' When
    actualResult = ts.__nodeUtils.areNodesTheSame(node1, node2)

    ' Then
    return ts.assertTrue(actualResult)
  end function)

  return ts
end function
