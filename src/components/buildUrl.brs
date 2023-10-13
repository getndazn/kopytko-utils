' Compose url with query strings. Values are encoded.
' @example
' ?buildUrl("http://myurl.com", { queryString: "123" })
' ' prints http://myurl.com?queryString=123
' @param {String} path
' @param {Object} [params=Invalid] - The AA of values convertible to string.
' @returns {String}
function buildUrl(path as String, params = Invalid as Object) as String
  ' It might be encoded already. To avoid encoding encoded url it needs to be decoded first.
  encodedPath = path.decodeUri().encodeUri()

  if (params = Invalid OR params.count() = 0)
    return encodedPath
  end if

  paramParts = []
  for each paramKey in params.keys()
    rawValue = params[paramKey]
    value = Invalid

    if (rawValue <> Invalid AND GetInterface(rawValue, "ifToStr") <> Invalid)
      value = rawValue.toStr()
    end if

    if (value <> Invalid AND value <> "")
      paramParts.push(paramKey.encodeUriComponent() + "=" + value.encodeUriComponent())
    else
      ?"buildUrl: '";paramKey;"' param is ignored because it can't be converted to string"
    end if
  end for

  if (paramParts.count() = 0)
    return encodedPath
  end if

  if (encodedPath.instr("?") > -1)
    return encodedPath + "&" + paramParts.join("&")
  end if

  return encodedPath + "?" + paramParts.join("&")
end function
