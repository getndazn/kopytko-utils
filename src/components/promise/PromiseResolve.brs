' @import /components/promise/Promise.brs

' Creates a resolved promise.
' @class
' @augments Promise
' @param {Dynamic} [value=Invalid]
function PromiseResolve(value = Invalid as Dynamic) as Object
  _promise = Promise()
  _promise.resolve(value)

  return _promise
end function
