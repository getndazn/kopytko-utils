' @import /components/reactiveX/RxObservable.brs

' Based on https://www.learnrxjs.io/learn-rxjs/operators/creation/from
' Turn an array into an observable.
' @class
' @augments RxObservable
' @param {Dynamic[]} values
function RxObservableFromArray(values as Object) as Object
  return RxObservable(sub (subscriber as Object, values as Object)
    for each value in values
      subscriber.next(value)
    end for

    subscriber.complete(m)
  end sub, values)
end function
