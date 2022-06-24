' @import /components/promise/Promise.brs
' @import /components/promise/PromiseResolve.brs

' Takes an array of promises as an input and returns a promise that resolves after all of the given promises have either fulfilled or rejected, 
' with an array of objects that each describes the outcome of each promise.
' @param {Promise[]} promiseInstances
' @returns {Promise}
function promisesAllSettled(promiseInstances as Object) as Object
  if (promiseInstances.count() = 0)
    return PromiseResolve(promiseInstances)
  end if

  context = {
    settledPromisesCount: 0,
    promises: promiseInstances,
    promise: Promise(),
  }

  context.onPromiseSettled = sub (value as Object, m as Object)
    m.settledPromisesCount++
    if (m.settledPromisesCount = m.promises.count())
      promisesValues = []
      for each _promise in m.promises
        promisesValues.push({ status: _promise.status, value: _promise.value })
      end for

      m.promise.resolve(promisesValues)
      m.promises.clear()
    end if
  end sub

  for each _promise in context.promises
    if (_promise.status = _promise.STATUS_FULFILLED OR _promise.status = _promise.STATUS_REJECTED)
      context.onPromiseSettled(_promise.value, context)
    else
      _promise.finally(context.onPromiseSettled, context)
    end if
  end for

  return context.promise
end function
