' @import /components/rokuComponents/EVPDigest.brs

' WARNING: the service must be used on the Task threads.
function CacheFS(constructorArgs = {} as Object) as Object
  prototype = {}

  prototype._PREFIX = "cachefs:/"

  prototype._digest = Invalid
  prototype._directory = Invalid
  prototype._fileSystem = Invalid

  _constructor = function (m as Object, constructorArgs as Object) as Object
    m._digest = EVPDigest()
    m._digest.setup("sha1")
    m._directory = ternary((getType(constructorArgs?.directory) = "roString"), constructorArgs.directory, "")
    m._fileSystem = CreateObject("roFileSystem")

    if (m._directory <> "") AND (NOT m._fileSystem.exists(m._PREFIX + m._directory))
      m._createDirectory()
    end if

    return m
  end function

  ' Reads data stored in cachefs under the specific key
  ' @param {String} key
  ' @returns {Object} Invalid if key is incorrect or is not stored
  prototype.read = function (key as String) as Object
    if (key = "") then return Invalid

    filePath = m._PREFIX + m._directory + m._hash(key)
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

    return WriteAsciiFile(m._PREFIX + m._directory + m._hash(key), content)
  end function

  ' Deletes data from cachefs under the specific key
  ' @param {String} key
  ' @returns {Boolean} true if data successfully removed
  prototype.delete = function (key as String) as Boolean
    if (key = "") then return false

    return DeleteFile(m._PREFIX + m._directory + m._hash(key))
  end function

  ' Clears all data from cachefs under the specific directory
  ' @returns {Boolean} true if all directory data is successfully removed
  prototype.clear = sub () as Boolean
    if (m._directory = "") then return false

    if (m._fileSystem.delete(m._PREFIX + m._directory))
      return m._createDirectory()
    end if

    return false
  end sub

  ' @private
  prototype._createDirectory = sub () as Boolean
    return m._fileSystem.createDirectory(m._PREFIX + m._directory)
  end sub

  ' @private
  prototype._hash = function (text as String) as String
    byteArray = CreateObject("roByteArray")
    byteArray.fromAsciiString(text)

    return m._digest.process(byteArray)
  end function

  return _constructor(prototype, constructorArgs)
end function
