' @import /components/rokuComponents/EVPDigest.brs

' WARNING: the service must be used on the Task threads.
function CacheFS(folder = "kopytkoCache" as String) as Object
  prototype = {}

  prototype._PREFIX = "cachefs:/"

  prototype._digest = Invalid
  prototype._fileSystem = Invalid
  prototype._folder = ""

  _constructor = function (m as Object, folder as String) as Object
    m._digest = EVPDigest()
    m._digest.setup("sha1")
    m._fileSystem = CreateObject("roFileSystem")
    m._folder = folder + "/"

    if (NOT m._fileSystem.exists(m._PREFIX + m._folder)) then m._createFolder()

    return m
  end function

  ' Reads data stored in cachefs under the specific key
  ' @param {String} key
  ' @returns {Object} Invalid if key is incorrect or is not stored
  prototype.read = function (key as String) as Object
    if (key = "") then return Invalid

    filePath = m._PREFIX + m._folder + m._hash(key)
    if (NOT m._fileSystem.exists(filePath)) then return Invalid

    content = ReadAsciiFile(filePath)

    return ParseJson(content, "i")
  end function

  ' Writes data into cachefs under the specific key
  ' @param {String} key
  ' @param {Object} data - any value acceptable by native FormatJson function except Invalid
  ' @returns {Boolean} false if data is not parseable, Invalid or if storing failed
  prototype.write = function (key as String, data as Object) as Boolean
    if (key = "" OR data = Invalid) then return false

    content = FormatJson(data)
    if (content = "") then return false

    return WriteAsciiFile(m._PREFIX + m._folder + m._hash(key), content)
  end function

  ' Deletes data from cachefs under the specific key
  ' @param {String} key
  ' @returns {Boolean} true if data successfully removed
  prototype.delete = function (key as String) as Boolean
    if (key = "") then return false

    return DeleteFile(m._PREFIX + m._folder + m._hash(key))
  end function

  ' Clears all data from cachefs under the specific directory
  ' @returns {Boolean} true if all directory data is successfully removed
  prototype.clear = sub () as Boolean
    if (m._fileSystem.delete(m._PREFIX + m._folder))
      return m._createFolder()
    end if

    return false
  end sub

  ' @private
  prototype._createFolder = sub () as Boolean
    return m._fileSystem.createDirectory(m._PREFIX + m._folder)
  end sub

  ' @private
  prototype._hash = function (text as String) as String
    byteArray = CreateObject("roByteArray")
    byteArray.fromAsciiString(text)

    return m._digest.process(byteArray)
  end function

  return _constructor(prototype, folder)
end function
