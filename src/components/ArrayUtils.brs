' @import /components/getProperty.brs
' @import /components/getType.brs

' Methods to operate on arrays.
' @class
function ArrayUtils() as Object
  prototype = {}

  ' Looks for an item, removes it from the source array and returns that item. It mutates the array. Returns Invalid when item is not found.
  ' @example
  ' ArrayUtils().pick([{ x: "a" }, { x: "b" }], function (item, desiredValue) : return (item.x = desiredValue) : end function), "b")
  ' ' => { x: "b" }
  ' @param {Dynamic[]} arrayToSearch
  ' @param {Function|AssociativeArray} predicate
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Dynamic} - Returns removed item. Invalid when not found.
  prototype.pick = function (arrayToSearch as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Dynamic
    index = m.findIndex(arrayToSearch, predicate, scopedData)
    if (index >= 0)
      item = arrayToSearch[index]
      arrayToSearch.delete(index)

      return item
    end if

    return Invalid
  end function

  ' Looks for an item in the array and returns it. Returns Invalid when item is not found.
  ' @param {Dynamic[]} arrayToSearch
  ' @param {Function|AssociativeArray} predicate
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Dynamic} - Returns the found item. Invalid when not found.
  prototype.find = function (arrayToSearch as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Dynamic
    index = m.findIndex(arrayToSearch, predicate, scopedData)
    if (index >= 0)
      return arrayToSearch[index]
    end if

    return Invalid
  end function

  ' Looks for an item in the array and returns its index.
  ' Warning: it does not compare node references.
  ' @param {Dynamic[]} arrayToSearch
  ' @param {Function|AssociativeArray} predicate
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Integer} - Returns item index or -1 when element is not found.
  prototype.findIndex = function (arrayToSearch as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Integer
    if (arrayToSearch = Invalid)
      return -1
    end if

    if (getType(predicate) = "roFunction")
      if (scopedData <> Invalid)
        for i = 0 to arrayToSearch.count() - 1
          item = arrayToSearch[i]
          if (predicate(item, scopedData))
            return i
          end if
        end for
      else
        for i = 0 to arrayToSearch.count() - 1
          item = arrayToSearch[i]
          if (predicate(item))
            return i
          end if
        end for
      end if

      return -1
    end if

    if (getType(predicate) = "roAssociativeArray")
      for i = 0 to arrayToSearch.count() - 1
        item = arrayToSearch[i]
        if (m._objectMatchesProperties(item, predicate))
          return i
        end if
      end for

      return -1
    else
      for i = 0 to arrayToSearch.count() - 1
        item = arrayToSearch[i]
        if (getType(item) = getType(predicate) AND item = predicate)
          return i
        end if
      end for
    end if

    return -1
  end function

  ' Filters out elements from the provided array. It returns new array of items that fulfill the predicate.
  ' @example
  ' elements = ArrayUtils().filter(["dog", "cat", "fish"], function (item as String) as Boolean
  '  return item = "dog"
  ' end function))
  ' ?elements ' ["dog"]
  ' @param {Dynamic[]} arrayToSearch
  ' @param {Function|AssociativeArray} predicate
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Array}
  prototype.filter = function (arrayToSearch as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Object
    return m._filter(arrayToSearch, predicate, scopedData, true)
  end function

  ' Creates new array based on source array and predicate.
  ' @param {Dynamic[]} arrayToMap
  ' @param {Function|String} predicate - It can be path when array item is an object.
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Array}
  prototype.map = function (arrayToMap as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Object
    mappedArray = []

    if (getType(predicate) = "roFunction")
      if (scopedData <> Invalid)
        for each item in arrayToMap
          mappedArray.push(predicate(item, scopedData))
        end for
      else
        for each item in arrayToMap
          mappedArray.push(predicate(item))
        end for
      end if
    else if (getType(predicate) = "roString")
      for each item in arrayToMap
        mappedArray.push(getProperty(item, predicate))
      end for
    end if

    return mappedArray
  end function

  ' Determines if given array contains given element.
  ' @param {Dynamic[]} arrayToSearch
  ' @param {Function|AssociativeArray} predicate
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Boolean}
  prototype.contains = function (arrayToSearch as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Boolean
    return (m.findIndex(arrayToSearch, predicate, scopedData) >= 0)
  end function

  ' The opposite of filter method. It returns the elements of collection that predicate does not return truthy for.
  ' @example
  ' elements = ArrayUtils().reject(["dog", "cat", "fish"], function (item as String) as Boolean
  '  return item = "dog"
  ' end function))
  ' ?elements ' ["cat", "fish"]
  ' @param {Dynamic[]} arrayToSearch
  ' @param {Function|AssociativeArray} predicate
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Array}
  prototype.reject = function (arrayToSearch as Object, predicate as Dynamic, scopedData = Invalid as Dynamic) as Object
    return m._filter(arrayToSearch, predicate, scopedData, false)
  end function

  ' Slices given array. It does not mutate source array. The endIndex is exclusive.
  ' @param {Dynamic[]} array
  ' @param {Integer} beginIndex
  ' @param {Integer} [endIndex=Invalid] - If not provided it returns all the left items.
  ' @returns {Array}
  prototype.slice = function (array as Object, beginIndex as Integer, endIndex = Invalid as Dynamic) as Object
    if (beginIndex > array.count() - 1)
      return []
    end if

    if (endIndex = Invalid OR endIndex > array.count())
      endIndex = array.count()
    end if

    slicedArray = []
    for i = beginIndex to endIndex - 1
      slicedArray.push(array[i])
    end for

    return slicedArray
  end function

  ' Creates an array of elements, sorted in an ascending order.
  ' See BrightScript native method ifArraySort.SortBy
  ' @example
  ' arrayToSort = [
  '   { id: 3, name: "item-1" },
  '   { id: 2, name: "item-2" },
  '   { id: 1, name: "item-3" },
  ' ]
  ' sorted = ArrayUtils().sortBy(arrayToSort, function (item as Object) as Integer
  '   return item.id
  ' end function)
  ' ?sorted
  ' ' prints
  ' '[
  ' '  { id: 1, name: "item-3" },
  ' '  { id: 2, name: "item-2" },
  ' '  { id: 3, name: "item-1" },
  ' ']
  ' @param {Dynamic[]} array
  ' @param {Function} sortByFunction - It should return any sortable type that can be procesed by ifArraySort.SortBy function.
  ' @param {Dynamic} [scopedData=Invalid] - Any data that is passed to predicate to deal with BrightScript variable scope.
  ' @returns {Array}
  prototype.sortBy = function(array as Object, sortByFunction as Function, scopedData = Invalid as Object) as Object
    sortedArray = []

    if (scopedData <> Invalid)
      for each item in array
        sortedArray.push({ item: item, fieldToSortBy: sortByFunction(item, scopedData) })
      end for
    else
      for each item in array
        sortedArray.push({ item: item, fieldToSortBy: sortByFunction(item) })
      end for
    end if

    sortedArray.sortBy("fieldToSortBy")

    return m.map(sortedArray, function (wrappedItem as Object) as Object
      return wrappedItem.item
    end function)
  end function

  ' @private
  prototype._filter = function (arrayToSearch as Object, predicate as Dynamic, scopedData as Dynamic, shouldMatchPredicate as Boolean) as Object
    results = []

    if (getType(predicate) = "roAssociativeArray")
      for i = 0 to arrayToSearch.count() - 1
        item = arrayToSearch[i]
        if (shouldMatchPredicate = m._objectMatchesProperties(item, predicate))
          results.push(item)
        end if
      end for
    else if (getType(predicate) = "roFunction")
      if (scopedData <> Invalid)
        for each item in arrayToSearch
          if (shouldMatchPredicate = predicate(item, scopedData))
            results.push(item)
          end if
        end for
      else
        for each item in arrayToSearch
          if (shouldMatchPredicate = predicate(item))
            results.push(item)
          end if
        end for
      end if
    else
      for each item in arrayToSearch
        doesPredicateMatch = (getType(item) = getType(predicate) AND item = predicate)
        if (shouldMatchPredicate = doesPredicateMatch)
          results.push(item)
        end if
      end for
    end if

    return results
  end function

  ' @private
  prototype._objectMatchesProperties = function (item as Object, properties as Object) as Boolean
    for each property in properties
      if (item[property] <> properties[property])
        return false
      end if
    end for

    return true
  end function

  return prototype
end function
