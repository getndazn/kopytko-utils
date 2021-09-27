' @import /components/getType.brs
' @import /components/reactiveX/RxSubscriber.brs
' @import /components/reactiveX/RxSubscription.brs

' The callback invoked when subscription to RxObervable is attached.
' @callback rxSubscribe
' @param {RxSubscriber} subscriber
' @param {Dynamic} [data=Invalid]

' Based on https://rxjs-dev.firebaseapp.com/api/index/class/Observable
' A simplified representation of Observable.
' @example
' subscribe = sub (subscriber as Object, data as Object)
'   subscriber.next(data.count)
' end sub
' observable = RxObservable(subscribe, { count: 10 })
' observable.subscribe({
'   next: sub (value as Dynamic)
'     ?value ' prints 10
'   end sub
' })
' @class
' @param {rxSubscribe} subscribe
' @param {Dynamic} [data=Invalid] - Any data that is passed to subscribe function
function RxObservable(subscribe as Function, data = Invalid as Dynamic) as Object
  prototype = {}

  prototype._data = data
  prototype._subscribe = subscribe

  ' Invokes an execution of an Observable and registers handlers for notifications it will emit.
  ' @param {Dynamic} observerOrNext
  ' @param {Dynamic} [error=Invalid]
  ' @param {Dynamic} [complete=Invalid]
  ' @param {Object} [subscriberContext=Invalid]
  ' @returns {RxSubscription|Invalid}
  prototype.subscribe = function (observerOrNext as Dynamic, error = Invalid as Dynamic, complete = Invalid as Dynamic, subscriberContext = Invalid as Object) as Object
    if (getType(observerOrNext) = "roAssociativeArray")
      observer = observerOrNext
      handlers = { "next": observer.next, error: observer.error, complete: observer.complete }
      subscriber = RxSubscriber(handlers, subscriberContext)
    else if (getType(observerOrNext) = "roFunction")
      _next = observerOrNext
      subscriber = RxSubscriber({ "next": _next, error: error, complete: complete }, subscriberContext)
    else
      return Invalid
    end if

    subscriber._unsubscribe = m._subscribe(subscriber, m._data)

    return RxSubscription(subscriber, m)
  end function

  return prototype
end function
