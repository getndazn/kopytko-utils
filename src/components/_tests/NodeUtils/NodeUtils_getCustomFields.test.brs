function TestSuite__NodeUtils_getCustomFields()
  ts = NodeUtilsTestSuite()
  ts.name = "NodeUtils - getCustomFields"

  ts.addTest("it returns only custom fields", function (ts as Object) as String
    ' Given
    customFields = {
      custom1: "custom1",
      custom2: "custom2",
      custom3: "custom3",
    }
    node = __createNode("node1")
    node.addFields(customFields)

    ' When
    actual = ts.__nodeUtils.getCustomFields(node)

    ' Then
    expected = customFields

    return ts.assertEqual(actual, expected)
  end function)

  return ts
end function
