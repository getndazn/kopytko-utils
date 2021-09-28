' Compose url with query strings. Values are encoded.
' @example
' ?buildUrl("http://myurl.com", { queryString: "123" })
' ' prints http://myurl.com?queryString=123
' @param {String} path
' @param {Object} [params=Invalid] - The AA of strings.
' @returns {String}
function buildUrl(path as String, params = Invalid as Object) as String
  ' It might be encoded already. To avoid encoding encoded url it needs to be decoded first.
  encodedPath = path.decodeUri().encodeUri()

  if (params = Invalid OR params.count() = 0)
    return encodedPath
  end if

  paramParts = []
  for each paramKey in params
    value = params[paramKey]
    if (value <> Invalid AND value <> "")
      paramParts.push(paramKey.encodeUriComponent() + "=" + value.encodeUriComponent())
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
