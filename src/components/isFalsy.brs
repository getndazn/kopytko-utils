' @import /components/getType.brs
function isFalsy(value as Dynamic) as Boolean
  falsyValues = [Invalid, false, "", 0]
  valueType = getType(value)

  for each falsyValue in falsyValues
    falsyValueType = getType(falsyValue)

    if (falsyValueType = valueType AND falsyValue = value) then return true
  end for

  return false
end function
