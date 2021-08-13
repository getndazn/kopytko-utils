' @import /components/getProperty.brs

' Node utils.
' @class
function NodeUtils() as Object
  prototype = {}

  ' Checks if nodes are the same by checking their reference.
  ' @param {Node} node1
  ' @param {Node} node2
  ' @returns {Boolean}
  prototype.areNodesTheSame = function (node1 as Object, node2 as Object) as Boolean
    if (node1 <> Invalid)
      return node1.isSameNode(node2)
    end if

    return (node2 = Invalid)
  end function

  ' Clones given node by creating new node of the same type. All the fields are cloned as well with exception to "change"
  ' and "focusedChild".
  ' @param {Node} source
  ' @returns {Node}
  prototype.cloneNode = function (source as Object) as Object
    clone = CreateObject("roSGNode", source.subtype())
    fields = source.getFields()
    fields.delete("change")
    fields.delete("focusedChild")

    clone.setFields(fields)

    return clone
  end function

  ' Gets all the custom node fields excluding "id", "focusedChild", "change", "focusable".
  ' @param {Node} source
  ' @returns {Object}
  prototype.getCustomFields = function (source as Object) as Object
    if (source = Invalid) then return {}

    fields = source.getFields()
    fields.delete("id")
    fields.delete("focusedChild")
    fields.delete("focusable")
    fields.delete("change")

    return fields
  end function

  ' Finds child of a node by id.
  ' Warning:
  ' Preferred way of referencing child node is to use native findNode method.
  ' Unfortunatelly Node and ContentNode can't be referenced by native method (roku bug in RokuOS 9.1 and earlier).
  ' The only possible way is to iterate through children and find correct node.
  ' More details https://forums.roku.com/viewtopic.php?f=34&t=104187&sid=c734efdb811d220cd0716ca191f79e35
  ' @param {Node} node
  ' @param {String} id
  ' @returns {Dynamic} - Returns Invalid when node is not found.
  prototype.findChildById = function (node as Object, id as String) as Dynamic
    return m.findChildByProperty(node, "id", id)
  end function

  ' Finds child node by given property value.
  ' @example
  ' ' Given node = <Node><Node user="{ isAdmin: true }"></Node></Node>
  ' NodeUtils().findChildByProperty(node, "user.isAdmin", true) ' Returns the first child
  ' @param {Node} node
  ' @param {String} propertyPath - It can be nested object.
  ' @param {Dynamic} value - The value that should match the searched value.
  ' @returns {Dynamic} - Returns Invalid when node is not found.
  prototype.findChildByProperty = function (node as Object, propertyPath as String, value as Dynamic) as Dynamic
    childIndex = m.findChildIndexByProperty(node, propertyPath, value)

    if (childIndex = Invalid)
      return Invalid
    end if

    return node.getChild(childIndex)
  end function

  ' Finds child node index by given property value.
  ' @example
  ' ' Given node = <Node><Node user="{ isAdmin: true }"></Node></Node>
  ' NodeUtils().findChildIndexByProperty(node, "user.isAdmin", true) ' Returns index 0
  ' @param {Node} node
  ' @param {String} propertyPath - It can be nested object.
  ' @param {Dynamic} value - The value that should match the searched value.
  ' @returns {Dynamic} - Returns Invalid when node is not found.
  prototype.findChildIndexByProperty = function (node as Object, propertyPath as String, value as Dynamic) as Dynamic
    indexVector = m.findChildIndexVectorByProperty(node, propertyPath, value)
    if (indexVector <> Invalid)
      return indexVector[0]
    end if

    return Invalid
  end function

  ' Finds child node vector by given property value.
  ' @example
  ' ' Given
  ' ' <Node>
  ' '  <Node>
  ' '   <Node></Node>
  ' '   <Node user="{ isAdmin: true }"></Node>
  ' '  </Node>
  ' ' </Node>
  ' NodeUtils().findChildIndexVectorByProperty(node, "user.isAdmin", true, 2) ' Returns [0][1]
  ' @param {Node} node
  ' @param {String} propertyPath - It can be nested object.
  ' @param {Dynamic} value - The value that should match the searched value.
  ' @param {Integer} [depth=1] - How deep the function should search.
  ' @returns {Dynamic} - Returns Invalid when node is not found.
  prototype.findChildIndexVectorByProperty = function (node as Object, propertyPath as String, value as Dynamic, depth = 1 as Integer) as Dynamic
    nodeLength = node.getChildCount()
    if (nodeLength = 0)
      return Invalid
    end if

    for i = 0 to nodeLength - 1
      child = node.getChild(i)
      if (depth = 1)
        if (getProperty(child, propertyPath) = value)
          return [i]
        end if
      else
        deeperIndex = m.findChildIndexVectorByProperty(child, propertyPath, value, depth - 1)
        if (deeperIndex <> Invalid)
          index = [i]
          index.append(deeperIndex)

          return index
        end if
      end if
    end for

    return Invalid
  end function

  ' Finds all children by given property value.
  ' @example
  ' ' Given
  ' ' <Node>
  ' '  <Node>
  ' '   <Node></Node>
  ' '   <Node user="{ isAdmin: true }"></Node>
  ' '   <Node user="{ isAdmin: true }"></Node>
  ' '  </Node>
  ' ' </Node>
  ' NodeUtils().findAllByProperty(node, "user.isAdmin", true, 2) ' Returns two nodes where value user.isAdmin is true
  ' @param {Node} node
  ' @param {String} propertyPath - It can be nested object.
  ' @param {Dynamic} value - The value that should match the searched value.
  ' @param {Integer} [depth=1] - How deep the function should search.
  ' @returns {Dynamic} - Returns Invalid when node is not found. Otherwise array of nodes.
  prototype.findAllByProperty = function (node as Object, propertyPath as String, value as Dynamic, depth = 1 as Integer) as Object
    results = []

    nodeLength = node.getChildCount()
    if (nodeLength = 0)
      return results
    end if

    for i = 0 to nodeLength - 1
      child = node.getChild(i)
      if (depth = 1)
        if (getProperty(child, propertyPath) = value)
          results.push(child)
        end if
      else
        deeperResults = m.findAllByProperty(child, propertyPath, value, depth - 1)
        results.append(deeperResults)
      end if
    end for

    return results
  end function

  ' Finds a child node by given vector.
  ' @param {Node} node
  ' @param {Object} indexVector - Array of indexes to locate the node.
  ' @returns {Dynamic} - Returns Invalid when node is not found.
  prototype.getItemByIndexVector = function (node as Object, indexVector as Object) as Dynamic
    if (node = Invalid) then return Invalid

    currentLevelNode = node
    for each index in indexVector
      nextLevelNode = currentLevelNode.getChild(index)
      if (nextLevelNode = Invalid)
        return Invalid
      end if

      currentLevelNode = nextLevelNode
    end for

    return currentLevelNode
  end function

  ' Iterator over children of a node.
  ' @example
  ' ' Given nodes = <Node><Node></Node></Node>
  ' NodeUtils().forEach(nodes, sub (node as Object, index as Integer): ?node end sub)
  ' @param {Node} node
  ' @param {Function} action
  ' @param {Dynamic} [scopedData=Invalid]
  prototype.forEachChild = sub (node as Object, action as Function, scopedData = Invalid as Dynamic)
    if (node = Invalid)
      return
    end if

    lastChildIndex = node.getChildCount() - 1

    for i = 0 to lastChildIndex
      child = node.getChild(i)

      if (scopedData = Invalid)
        action(child, i)
      else
        action(child, i, scopedData)
      end if
    end for
  end sub

  return prototype
end function
