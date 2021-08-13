' Assertion logic.
' @class
function Assert() as Object
  prototype = {}

  ' Asserts if two values are deeply equal whatever its type might be.
  ' @param {Dynamic} valueA
  ' @param {Dynamic} valueB
  ' @returns {Boolean}
  prototype.deepEqual = function (valueA as Dynamic, valueB as Dynamic) as Boolean
    if (Type(Box(valueA), 3) <> Type(Box(valueB), 3))
      return false
    end if

    valuesType = Type(valueA)

    if (valuesType = "roSGNode")
      return (valueA.isSameNode(valueB))
    end if

    if (valuesType = "roArray")
      return m._areArraysDeeplyEqual(valueA, valueB)
    end if

    if (valuesType = "roAssociativeArray")
      return m._areAssocArraysDeeplyEqual(valueA, valueB)
    end if

    return (valueA = valueB)
  end function

  ' @private
  prototype._areArraysDeeplyEqual = function (arrayA as Object, arrayB as Object) as Boolean
    if (arrayA.count() <> arrayB.count())
      return false
    end if

    for i = 0 to arrayA.count() - 1
      if (NOT m.deepEqual(arrayA[i], arrayB[i]))
        return false
      end if
    end for

    return true
  end function

  ' @private
  prototype._areAssocArraysDeeplyEqual = function (assocArrayA as Object, assocArrayB as Object) as Boolean
    if (assocArrayA.count() <> assocArrayB.count())
      return false
    end if

    for each key in assocArrayA
      if (NOT m.deepEqual(assocArrayA[key], assocArrayB[key]))
        return false
      end if
    end for

    return true
  end function

  return prototype
end function
