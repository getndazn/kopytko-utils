' @import /components/functionCall.brs
' @import /components/uuid.brs

' Represents subscriber. Main reason of existence is to deliver proper context.
' Theoretically it should implement Observer entity but so far we don't need it.
' Theoretically is should extend Subscription, but because of BS limitations, we have to pass subscriber and observable
' via Subscriptions's constructor into unsubscribe method to call it in a proper context.
' @class
' @param {Object} handlers
' @param {Function} handlers.next
' @param {Function} handlers.error
' @param {Function} handlers.complete
' @param {Object} context
function RxSubscriber(handlers as Object, context as Object) as Object
  prototype = {}

  ' Identifier.
  ' @type {String}
  prototype.id = uuid()

  ' @protected
  prototype._unsubscribe = Invalid

  ' @private
  prototype._context = context

  ' @private
  prototype._handlers = handlers

  ' @private
  prototype._isUnsubscribed = false

  ' Wrapper function for next caller.
  ' @param {Dynamic} value
  prototype.next = sub (value as Dynamic)
    if (NOT m._isUnsubscribed)
      functionCall(m._handlers.next, [value], m._context)
    end if
  end sub

  ' Wrapper function for error caller.
  ' @param {Dynamic} error
  ' @param {RxObservable} observable
  prototype.error = sub (error as Dynamic, observable as Object)
    if (m._isUnsubscribed) then return

    functionCall(m._handlers.error, [error], m._context)

    m.unsubscribe(observable)
  end sub

  ' Wrapper function for complete caller.
  ' @param {RxObservable} observable
  prototype.complete = sub (observable as Object)
    if (m._isUnsubscribed) then return

    functionCall(m._handlers.complete, [], m._context)

    m.unsubscribe(observable)
  end sub

  ' Wrapper function for unsubscribe caller.
  ' @param {RxObservable} observable
  prototype.unsubscribe = sub (observable as Object)
    m._isUnsubscribed = true

    functionCall(m._unsubscribe, [m], observable)
  end sub

  return prototype
end function
