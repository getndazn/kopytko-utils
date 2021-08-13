' Based on https://rxjs.dev/guide/subscription
' A Subscription is an object that represents a disposable resource, usually the execution of an Observable.
' @class
' @param {RxSubscriber} subscriber
' @param {RxObservable} observable
function RxSubscription(subscriber as Object, observable as Object) as Object
  prototype = {}

  ' @private
  prototype._observable = observable

  ' @private
  prototype._subscriber = subscriber

  ' Removes observable from subscriber.
  prototype.unsubscribe = sub ()
    m._subscriber.unsubscribe(m._observable)
  end sub

  return prototype
end function
