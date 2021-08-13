' Math utils.
' @class
function MathUtils() as Object
  prototype = {}

  ' @constant
  ' @type {Float}
  prototype.PI = 3.14

  ' Degress to radians conversion.
  ' @param {Float} degrees
  ' @returns {Float}
  prototype.toRadians = function (degrees as Float) as Float
    return (degrees * m.PI) / 180
  end function

  ' Rounds up the value to the nearest integer.
  ' @param {Float} number
  ' @returns {Integer}
  prototype.ceil = function (number as Float) as Integer
    rounded = Int(number)
    if (rounded < number)
      rounded++
    end if

    return rounded
  end function

  ' Finds the minimal value in the given set.
  ' @param {Integer[]|Float[]|LongInteger[]} numberArray
  ' @returns {Dynamic} - Returns Invalid when source object can't be sorted.
  prototype.min = function (numberArray as Object) as Dynamic
    if (GetInterface(numberArray, "ifArraySort") = Invalid OR numberArray.count() = 0)
      return Invalid
    end if

    numberArrayCopy = []
    numberArrayCopy.append(numberArray)
    numberArrayCopy.sort()

    return numberArrayCopy[0]
  end function

  ' Finds the maximal value in the given set.
  ' @param {Integer[]|Float[]|LongInteger[]|Double[]} numberArray
  ' @returns {Dynamic} - Returns Invalid when source object can't be sorted.
  prototype.max = function (numberArray as Object) as Dynamic
    if (GetInterface(numberArray, "ifArraySort") = Invalid OR numberArray.count() = 0)
      return Invalid
    end if

    numberArrayCopy = []
    numberArrayCopy.append(numberArray)
    numberArrayCopy.sort()

    return numberArrayCopy[numberArrayCopy.count() - 1]
  end function

  return prototype
end function
