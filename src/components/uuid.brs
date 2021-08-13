' Generates uuid in a naive way.
' The purpose of the function is to generate identifiers faster then native brightscript uuid generator.
' It is intended to be used internaly for i.e. component ids on a small scale as it relies on pseudo random number generator.
' For other purposes use ifDeviceInfo.GetRandomUUID.
' Parts length: 8-4-4-4-12
' @example fnwijen2-n51i-jni1-5jd5-1234jjkjnfe2
' @returns {String}
function uuid() as String
  parts = [
    _uuidGetRandomHexString(8),
    _uuidGetRandomHexString(4),
    _uuidGetRandomHexString(4),
    _uuidGetRandomHexString(4),
    _uuidGetRandomHexString(12),
  ]

  return parts.join("-")
end function

function _uuidGetRandomHexString(length as Integer) as String
  hexChars = "0123456789ABCDEF"
  hexCharsNumber = Len(hexChars)
  hexString = ""

  for i = 1 to length
    hexString += hexChars.mid(Rnd(hexCharsNumber) - 1, 1)
  end for

  return hexString
end function
