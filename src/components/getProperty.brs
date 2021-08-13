' Returns a value of the source object for the given path.
' If not found, returns passed default value (Invalid by default).
' Path can be a string ("a.b.c") or an array (["a", "b", "c"])
' @example
' getProperty({ a: { b: "value" } }, "a.b") ' returns "value"
' @param {Object} source
' @param {String[]|String} path
' @param {Dynamic} [defaultValue=Invalid]
function getProperty(source as Object, path as Dynamic, defaultValue = Invalid as Dynamic) as Dynamic
  if (path = Invalid)
    return defaultValue
  end if

  if (Type(path) = "String" OR Type(path) = "roString")
    keys = path.split(".")
  else
    keys = path
  end if
  currentSource = source

  for each key in keys
    if (currentSource = Invalid OR key = Invalid) then return defaultValue
    if (Type(currentSource) <> "roAssociativeArray" AND Type(currentSource) <> "roSGNode") then return defaultValue

    currentSource = currentSource[key]
  end for

  if (currentSource = Invalid)
    return defaultValue
  end if

  return currentSource
end function
