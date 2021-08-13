' The Promise object represents the eventual completion (or failure) of an asynchronous operation,
' and its resulting value.
' Warning: the promise does not work between threads and Scenegraph components (functions can't be stored as node fields).
' @class
function Promise() as Object
  prototype = {}

  ' Status value in case of pending promise.
  ' @constant
  ' @type {Integer}
  prototype.STATUS_PENDING = 0

  ' Status value in case of resolved promise.
  ' @constant
  ' @type {Integer}
  prototype.STATUS_FULFILLED = 1

  ' Status value in case of rejected promise.
  ' @constant
  ' @type {Integer}
  prototype.STATUS_REJECTED = 2

  ' Current status of the Promise.
  ' @type {String}
  ' @default STATUS_PENDING
  prototype.status = prototype.STATUS_PENDING

  ' Current value of the Promise.
  ' @type {Dynamic}
  ' @default Invalid
  prototype.value = Invalid

  ' @private
  prototype._callbacks = []

  ' Callbacks fired when either Promise resolves or rejects.
  ' @param {Function} [onFulfilled=Invalid] - Callback fires when Promise resolves.
  ' @param {Function} [onRejected=Invalid]  - Callback fires when Promise rejects.
  ' @param {Object} [context=Invalid] - The context for the provided callbacks.
  prototype.then = function (onFulfilled = Invalid as Object, onRejected = Invalid as Object, context = Invalid as Object) as Dynamic
    if (m.status = m.STATUS_PENDING)
      callbackPromise = Promise()
      ' Storing callbacks in array solves scope issues
      ' (but only when working with compontents - doesn't work for prototype objects)
      m._callbacks.push({
        resolve: [onFulfilled],
        reject: [onRejected],
        promise: callbackPromise,
        context: context,
      })

      return callbackPromise
    else
      if (m.status = m.STATUS_FULFILLED)
        callback = onFulfilled
      else
        callback = onRejected
      end if

      if (callback <> Invalid)
        result = m._executeCallbackAction(callback, m.value, context)
      else
        result = m ' pass completed promise further
      end if
    end if

    if (m._isPromise(result))
      return result
    end if

    if (m.status = m.STATUS_FULFILLED)
      return PromiseResolve(result)
    else
      return PromiseReject(result)
    end if
  end function

  ' Callback fired when Promise rejects.
  ' It is shorthand for then method.
  ' @param {Function} onRejected - Callback fires when Promise rejects.
  ' @param {Object} [context=Invalid] - The context for the provided callback.
  ' @returns {Dynamic}
  prototype.catch = function (onRejected as Function, context = Invalid as Object) as Dynamic
    return m.then(Invalid, onRejected, context)
  end function

  ' Callback fired when the promise is rejected or resolved.
  ' Differences between JS Promise.prototype.finally and this implementation:
  ' - onFinally callback function has to have one argument (JS implementation is non-argument)
  ' - finally() doesn't return resolved/rejected promise based on the previous state of the promise chain
  ' @param {Function} onFinally - Callback fires when Promise rejects/resolves.
  ' @param {Object} [context=Invalid] - The context for the provided callback.
  prototype.finally = sub (onFinally as Function, context = Invalid as Object)
    ' @todo wrap the onFinally callback so it won't have to have one argument
    m.then(onFinally, onFinally, context)
  end sub

  ' Resolves the Promise with a given value.
  ' @param {Dynamic} [value=Invalid]
  ' @returns {Promise}
  prototype.resolve = function (value = Invalid as Dynamic) as Object
    m._complete("resolve", value)

    return m
  end function

  ' Rejects the Promise with a given value.
  ' @param {Dynamic} [exception=Invalid]
  ' @returns {Promise}
  prototype.reject = function (exception = Invalid as Dynamic) as Object
    m._complete("reject", exception)

    return m
  end function

  ' @private
  prototype._complete = sub (action as String, argument as Dynamic)
    if (m.status <> m.STATUS_PENDING)
      m._onAlreadyResolved()
    else
      m.value = argument
      isResolved = (action = "resolve")
      if (isResolved)
        m.status = m.STATUS_FULFILLED
      else
        m.status = m.STATUS_REJECTED
      end if

      for i = 0 to m._callbacks.count() - 1
        callback = m._callbacks[i]
        callbackAction = callback[action][0]
        result = m._executeCallbackAction(callbackAction, argument, callback.context)

        if (m._isPromise(result))
          if (result.status = m.STATUS_PENDING)
            result._callbacks.append(callback.promise._callbacks)
          else if (result.status = m.STATUS_FULFILLED) ' result is an PromiseResolve() object
            callback.promise.resolve(result.value)
          else ' result is an PromiseReject() object
            callback.promise.reject(result.value)
          end if
        ' Chained promise should be rejected when failure was not handled, otherwise it should be resolved
        else if (NOT isResolved AND callbackAction = Invalid)
          callback.promise.reject(argument)
        else
          if (callbackAction = Invalid)
            ' onFulfilled wasn't passed (potentially because of .catch() execution), so there is no callbackAction
            ' and the argument should be redirected further (to be handled by the next .then() in the promise chain)
            callback.promise.resolve(argument)
          else
            callback.promise.resolve(result)
          end if
        end if
      end for
    end if

    m._callbacks.clear()
  end sub

  ' @private
  prototype._executeCallbackAction = function (callback as Dynamic, param as Dynamic, context = Invalid as Object) as Object
    if (callback = Invalid) then return Invalid

    if (context = Invalid)
      return callback(param)
    end if

    return callback(param, context)
  end function

  ' @private
  prototype._onAlreadyResolved = sub ()
    print "[Promise] Trying to complete already completed promise"
  end sub

  ' @private
  prototype._isPromise = function (result as Object) as Boolean
    return (Type(result) = "roAssociativeArray" AND result.doesExist("_isPromise"))
  end function

  return prototype
end function
