' @import /components/getType.brs
' @import /components/ternary.brs

' Object utils.
' @class
function ObjectUtils() as Object
  prototype = {}

  ' Inverts key with value if value can be casted to string. Otherwise key is omitted. It does not mutate original object.
  ' Warning: Keys not surrounded by quotation marks will be lowercased.
  ' @example
  ' obj = {
  '   "keyToBeInverted": "valueToBeInverted",
  ' }
  ' ?ObjectUtils().invert(obj)
  ' ' prints
  ' ' obj = {
  ' '  "valueToBeInverted": "keyToBeInverted"
  ' ' }
  ' @param {Object} obj
  ' @returns {Object}
  prototype.invert = function (obj as Object) as Object
    inverted = {}

    for each item in obj.items()
      if (GetInterface(item.value, "ifToStr") <> Invalid)
        inverted[item.value.toStr()] = item.key
      end if
    end for

    return inverted
  end function

  ' Merges one or more objects into given object.
  ' It merges arrays by appending items.
  ' It merges associative arrays by copying fields.
  ' it merges nodes by passing references (without deep copy).
  ' @param {Object} source - The source object which will be extended.
  ' @param {Array|AssociativeArray} extenders - The objectes that extend the source object.
  ' @returns {Object} - The merged source object.
  prototype.merge = function (source as Object, extenders as Object) as Object
    if (getType(source) <> "roAssociativeArray")
      return Invalid
    end if

    normalizedExtenders = ternary(getType(extenders) = "roArray", extenders, [extenders])
    result = source

    for each extender in normalizedExtenders
      if (getType(extender) = "roAssociativeArray")
        for each key in extender.keys()
          sourceItemType = getType(extender[key])
          resultItemType = getType(result[key])
          if (resultItemType = "roArray" AND sourceItemType = "roArray")
            result[key].append(extender[key])
          else if (resultItemType = "roAssociativeArray" AND sourceItemType = "roAssociativeArray")
            m.merge(result[key], extender[key])
          else if (extender[key] <> Invalid)
            result[key] = extender[key]
          end if
        end for
      end if
    end for

    return result
  end function

  ' Picks keys and values from the source object.
  ' @example
  ' obj = { key1: "test1", key2: "test2", key3: "test3" }
  ' ?ObjectUtils().pick(obj, ["key2", "key3"])
  ' ' prints
  ' ' obj = { key2: "test2", key3: "test3" }
  ' @param {Object} source
  ' @param {Array} keys
  ' @returns {Object}
  prototype.pick = function (source as Object, keys as Object) as Object
    picked = {}

    for each key in keys
      picked[key] = source[key]
    end for

    return picked
  end function

  ' Deep print the nested object till specified level
  ' @example
  ' obj = {
  '   "key11": "value11",
  '   "key12": {
  '     "key21": "value21",
  '     "key22": {
  '       "key31": "value31",
  '     },
  '   },
  ' }
  ' ObjectUtils().print(obj, 2)
  ' prints
  ' {
  '   key11 : value11,
  '   key12 {
  '     key21 : value21,
  '     key22 { object },
  '   },
  ' }
  ' @param {Object} obj
  ' @param {Integer} nestedUntil [default value is 3] - Object nesting level till it should be printed
  prototype.print = function (obj as object, nestedUntil = 3 as integer)
    if (nestedUntil < 1)
      print "{ object }" 
      return true
    end if
    
    print "{"
    m._printNestedObject(obj, nestedUntil)
    print "}"
  end function

  ' @private
  prototype._printNestedObject = function (obj as Object, nestedUntil as Integer, currentLevel = 1 as Integer)
    indentationValue = 2
    tabValue = currentLevel * indentationValue

    for each property in obj.items()
      if (getType(property.value) = "roAssociativeArray" OR getType(property.value) = "roSGNode")
        if (currentLevel < nestedUntil)
          m._printFormattedString(tabValue, Substitute("{0} {", property.key))
          m._printNestedObject(property.value, nestedUntil, currentLevel + 1)
        else
          m._printFormattedString(tabValue, Substitute("{0} { object },", property.key))
        end if
      else
        m._printFormattedString(tabValue, Substitute("{0} : {1},", property.key, property.value.toStr()))
      end if
    end for

    if (currentLevel > 1) then m._printFormattedString((tabValue - indentationValue), "},")
  end function

  ' @private
  prototype._printFormattedString = function (tabValue as Integer, str as String)
    print Tab(tabValue) str
  end function

  return prototype
end function
