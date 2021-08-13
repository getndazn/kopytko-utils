' Casts argument to object representation and determines its type.
' @param {Dynamic} value
' @returns {String}
function getType(value as Dynamic) as String
  return Type(Box(value), 3)
end function
