' @import /components/promise/Promise.brs
' @import /components/promise/PromiseReject.brs

' Takes an array of promises as an input and resolves with an item that is resolved as the first one. If all promises
' reject the underlying promise rejects as well.
' @param {Promise[]} promiseInstances
' @returns {Promise}
function promisesAny(promiseInstances as Object) as Object
  if (promiseInstances.count() = 0)
    return PromiseReject()
  end if

  context = {
    rejectedPromisesCount: 0,
    promises: promiseInstances,
    promise: Promise(),
  }

  ' Resolves promise with the value of the first promise that was resolved
  context.onPromiseFulfilled = sub (value as Object, m as Object)
    if (m.promise.status = m.promise.STATUS_PENDING)
      m.promise.resolve(value)
      m.promises.clear()
    end if
  end sub

  context.onPromiseRejected = sub (reason as Object, m as Object)
    m.rejectedPromisesCount++
    if (m.rejectedPromisesCount = m.promises.count())
      promisesValues = []
      for each _promise in m.promises
        promisesValues.push(_promise.value)
      end for

      m.promise.reject(promisesValues)
      m.promises.clear()
    end if
  end sub

  for each _promise in context.promises
    if (_promise.status = _promise.STATUS_FULFILLED)
      context.onPromiseFulfilled(_promise.value, context)

      return context.promise ' No need to iterate further because context.promise is resolved
    else if (_promise.status = _promise.STATUS_REJECTED)
      context.onPromiseRejected(_promise.value, context)
    else
      _promise.then(context.onPromiseFulfilled, context.onPromiseRejected, context)
    end if
  end for

  return context.promise
end function
