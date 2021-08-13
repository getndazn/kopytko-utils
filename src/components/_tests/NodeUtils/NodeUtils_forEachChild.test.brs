function TestSuite__NodeUtils_forEachChild()
  ts = NodeUtilsTestSuite()
  ts.name = "NodeUtils - forEachChild"

  ts.addTest("it doesn't apply action for Invalid node", function (ts as Object) as String
    ' Given
    node = Invalid
    m.__wasActionApplied = false

    ' When
    actualResult = ts.__nodeUtils.forEachChild(node, sub (child as Object, m as Object)
      m.__wasActionApplied = true
    end sub, m)

    ' Then
    return ts.assertFalse(m.__wasActionApplied)
  end function)

  ts.addTest("it applies action for each child", function (ts as Object) as String
    ' Given
    node = __createNode("node1")
    child1 = __createNode("child1")
    child2 = __createNode("child2")
    node.appendChildren([child1, child2])
    childrenWithAppliedAction = []

    ' When
    actualResult = ts.__nodeUtils.forEachChild(node, sub (child as Object, index as Integer, m as Object)
      m.childrenWithAppliedAction.push(child.id)
    end sub, { childrenWithAppliedAction: childrenWithAppliedAction })

    ' Then
    expected = ["child1", "child2"]
    actual = childrenWithAppliedAction

    return ts.assertEqual(actual, expected)
  end function)

  return ts
end function
