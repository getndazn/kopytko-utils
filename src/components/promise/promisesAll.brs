' @import /components/promise/Promise.brs
' @import /components/promise/PromiseResolve.brs

' Takes an array of promises as an input and resolves with an array when all of the promises are resolved. If any promise
' rejects the underlying promise rejects immediately.
' @param {Promise[]} promiseInstances
' @returns {Promise}
function promisesAll(promiseInstances as Object) as Object
  if (promiseInstances.count() = 0)
    return PromiseResolve(promiseInstances)
  end if

  context = {
    fulfilledPromisesCount: 0,
    promises: promiseInstances,
    promise: Promise(),
  }

  context.onPromiseFulfilled = sub (value as Object, m as Object)
    m.fulfilledPromisesCount++
    if (m.fulfilledPromisesCount = m.promises.count())
      promisesValues = []
      for each _promise in m.promises
        promisesValues.push(_promise.value)
      end for

      m.promise.resolve(promisesValues)
      m.promises.clear()
    end if
  end sub

  ' Rejects promise with the reason of the first promise that was rejected
  context.onPromiseRejected = sub (reason as Object, m as Object)
    if (m.promise.status = m.promise.STATUS_PENDING)
      m.promise.reject(reason)
      m.promises.clear()
    end if
  end sub

  for each _promise in context.promises
    if (_promise.status = _promise.STATUS_FULFILLED)
      context.onPromiseFulfilled(_promise.value, context)
    else if (_promise.status = _promise.STATUS_REJECTED)
      context.onPromiseRejected(_promise.value, context)

      return context.promise ' No need to iterate further because context.promise is rejected
    else
      _promise.then(context.onPromiseFulfilled, context.onPromiseRejected, context)
    end if
  end for

  return context.promise
end function
