' This utility helps to to access and manage the node context.
' When called from the prototype-based entity it refers to the context of the node that owns the entity.
' @class
function SharedNodeContextFacade() as Object
  if (m._sharedNodeContext = Invalid)
    m._sharedNodeContext = {}
  end if

  prototype = {}

  ' Gets the value for the given key.
  ' @param {String} key
  ' @returns {Dynamic}
  prototype.get = function (key as String) as Dynamic
    return m._getSharedNodeContext()[key]
  end function

  ' Sets the value for the given key.
  ' @param {String} key
  ' @param {Dynamic} value
  prototype.set = sub (key as String, value as Dynamic)
    m._getSharedNodeContext()[key] = value
  end sub

  ' Removes the value for the given key.
  ' @param {String} key
  prototype.clear = sub (key as String)
    m._getSharedNodeContext()[key] = Invalid
  end sub

  ' @private
  prototype._getSharedNodeContext = function () as Object
    return GetGlobalAA()._sharedNodeContext
  end function

  return prototype
end function
