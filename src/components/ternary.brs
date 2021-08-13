' Function that acts as ternary.
' @todo Detect if the second or third argument is a function and lazy call it when needed.
' @param {Boolean} conditionResult
' @param {Dynamic} trueReturnValue
' @param {Dynamic} falseReturnValue
' @returns {Dynamic}
function ternary(conditionResult as Boolean, trueReturnValue as Dynamic, falseReturnValue as Dynamic) as Dynamic
  if (conditionResult)
    return trueReturnValue
  end if

  return falseReturnValue
end function
