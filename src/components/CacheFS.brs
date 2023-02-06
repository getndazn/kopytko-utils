' @import /components/rokuComponents/EVPDigest.brs
function CacheFS() as Object
  prototype = {}

  prototype._PREFIX = "cachefs:/"

  prototype._digest = Invalid

  _constructor = function (m as Object) as Object
    m._digest = EVPDigest()
    m._digest.setup("sha1")

    return m
  end function

  ' Reads data stored in cachefs under the specific key
  ' @param {String} key
  ' @returns {Object}
  prototype.read = function (key as String) as Object
    if (key = "") then return Invalid

    content = ReadAsciiFile(m._PREFIX + m._hash(key))
    if (content = "") then return Invalid

    return ParseJson(content)
  end function

  ' Writes data into cachefs under the specific key
  ' @param {String} key
  ' @param {Object} data - associative array data
  ' @returns {Boolean} true if data successfully stored
  prototype.write = function (key as String, data as Object) as Boolean
    if (key = "") then return false

    content = FormatJson(data)

    return WriteAsciiFile(m._PREFIX + m._hash(key), content)
  end function

  ' Deletes data from cachefs under the specific key
  ' @param {String} key
  ' @returns {Boolean} true if data successfully removed
  prototype.delete = function (key as String) as Boolean
    if (key = "") then return false

    return DeleteFile(m._PREFIX + m._hash(key))
  end function

  ' @private
  prototype._hash = function (text as String) as String
    byteArray = CreateObject("roByteArray")
    byteArray.fromAsciiString(text)

    return m._digest.process(byteArray)
  end function

  return _constructor(prototype)
end function
