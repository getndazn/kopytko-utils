' @import /components/getType.brs
' @import /components/rokuComponents/EVPDigest.brs
function CacheFS() as Object
  prototype = {}

  prototype._PREFIX = "cachefs:/"

  prototype._digest = Invalid
  prototype._fileSystem = Invalid

  _constructor = function (m as Object) as Object
    m._digest = EVPDigest()
    m._digest.setup("sha1")
    m._fileSystem = CreateObject("roFileSystem")

    return m
  end function

  ' Reads data stored in cachefs under the specific key
  ' @param {String} key
  ' @returns {Object}
  prototype.read = function (key as String) as Object
    if (key = "") then return Invalid

    filePath = m._PREFIX + m._hash(key)
    if (NOT m._fileSystem.exists(filePath)) then return Invalid

    content = ReadAsciiFile(filePath)

    return ParseJson(content)
  end function

  ' Writes data into cachefs under the specific key
  ' @param {String} key
  ' @param {Object} data - associative array data
  ' @returns {Boolean} true if data successfully stored
  prototype.write = function (key as String, data as Object) as Boolean
    if (key = "" OR data = Invalid) then return false

    content = FormatJson(data)
    if (content = "" AND getType(data) <> "roString") then return false

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
