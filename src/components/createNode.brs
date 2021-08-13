' Creates node component i.e. Node, ContentNode, Poster etc.
' @param {String} [name="Node"]
' @returns {Node}
function createNode(name = "Node" as String) as Object
  return CreateObject("roSGNode", name)
end function
