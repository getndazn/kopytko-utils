' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function NodeUtilsTestSuite()
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    ts.__nodeUtils = NodeUtils()
  end sub)

  return ts
end function

function __createNode(id as String) as Object
  node = CreateObject("roSGNode", "Node")
  node.id = id

  return node
end function

function __createComplexNode(value as String) as Object
  node = CreateObject("roSGNode", "Node")
  node.addFields({ complex: { key: value } })

  return node
end function
