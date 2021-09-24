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

  return prototype
end function
