' @import /components/promise/Promise.brs

' Creates a rejected promise.
' @class
' @augments Promise
' @param {Dynamic} [exception=Invalid]
function PromiseReject(exception = Invalid as Dynamic) as Object
  _promise = Promise()
  _promise.reject(exception)

  return _promise
end function
