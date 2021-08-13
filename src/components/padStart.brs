' Based od https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart
' The method pads the current string with another string (multiple times, if needed) until the resulting string reaches
' the given length. The padding is applied from the start of the current string.
' @param {String} value
' @param {Integer} length
' @param {String} [char=""]
' @returns {String}
function padStart(value as String, length as Integer, char = "" as String) as String
  if (Len(value) < length)
    return String(length - Len(value), char) + value
  end if

  return value
end function
