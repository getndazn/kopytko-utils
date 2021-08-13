' @import /components/promise/PromiseResolve.brs

' Takes promise as an input and:
' - resolves with value and isFulfilled flag set to true when promise is resolved
' - resolves with a reason and isFulfilled flag set to false when promise is rejected
' @param {Promise} _promise
' @returns {Promise}
function reflectPromise(_promise as Object) as Object
  return _promise.then(function (value as Dynamic) as Object
    return { value: value, isFulfilled: true }
  end function, function (reason as Dynamic) as Object
    return PromiseResolve({ reason: reason, isFulfilled: false })
  end function)
end function
