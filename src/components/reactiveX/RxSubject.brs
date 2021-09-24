' @import /components/ArrayUtils.brs
' @import /components/reactiveX/RxObservable.brs
' @import /components/reactiveX/RxSubscription.brs

' Based on https://rxjs-dev.firebaseapp.com/api/index/class/Subject
' Every Subject is an Observable and an Observer. You can subscribe to a Subject, and you can call next to feed values
' as well as error and complete.
' @class
' @augments RxObservable
function RxSubject() as Object
  prototype = RxObservable(function (subscriber as Object, data as Dynamic) as Function
    m._subscribers.push(subscriber)

    return sub (subscriber as Object)
      ArrayUtils().pick(m._subscribers, { id: subscriber.id })
    end sub
  end function)

  ' @private
  prototype._isStopped = false

  ' @private
  prototype._subscribers = [] ' theoretically it should be "observers" but we implemented only the Subscriber model

  ' Fires next method of subcribers with given value.
  ' @param {Dynamic} value - The value that feeds the next method of subscribers.
  prototype.next = sub (value as Dynamic)
    if (m._isStopped) then return

    for each subscriber in m._subscribers
      subscriber.next(value)
    end for
  end sub

  ' Fires error method of subscribers and removes current observers.
  ' @param {Dynamic} error - The value that feeds the error method of subscribers.
  prototype.error = sub (error as Dynamic)
    if (m._isStopped) then return

    m._isStopped = true

    while (NOT m._subscribers.isEmpty())
      m._subscribers.shift().error(error, m)
    end while
  end sub

  ' Fires complete method of subscribers and removes current observers.
  prototype.complete = sub ()
    if (m._isStopped) then return

    m._isStopped = true

    while (NOT m._subscribers.isEmpty())
      m._subscribers.shift().complete(m)
    end while
  end sub

  ' Unsibscribe all subscribers.
  prototype.unsubscribe = sub ()
    m._isStopped = true
    m._subscribers = []
  end sub

  ' Create new observable.
  ' @returns {RxObservable}
  prototype.asObservable = function () as Object
    return RxObservable(function (subscriber as Object, subject as Dynamic) as Function
      subject._subscribers.push(subscriber)

      return sub (subscriber as Object)
        ArrayUtils().pick(m._subscribers, { id: subscriber.id })
      end sub
    end function, m)
  end function

  return prototype
end function
