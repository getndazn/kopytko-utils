' @import /components/reactiveX/RxObservable.brs

' Based on https://rxjs-dev.firebaseapp.com/api/index/function/combineLatest
' Combines multiple Observables to create an Observable whose values are calculated from the latest values of each of its input Observables.
' @param {RxObservable[]} observables
' @returns {RxObservable}
function rxCombineLatest(observables as Object) as Object
  return RxObservable(sub (subscriber as Object, sources as Object)
    values = {}

    for i = 0 to sources.count() - 1
      sourceSubscriberContext = {
        count: sources.count(),
        index: i.toStr(),
        subscriber: subscriber,
        values: values,
      }
      observable = sources[i]
      observable.subscribe(sub (value)
        ' m is sourceSubscriberContext
        m.values[m.index] = value

        canNotify = true
        for i = 0 to m.count - 1
          if (NOT m.values.doesExist(i.toStr()))
            canNotify = false
          end if
        end for

        if (canNotify)
          values = []
          for i = 0 to m.count - 1
            values.push(m.values[i.toStr()])
          end for

          m.subscriber.next(values)
        end if
      end sub, Invalid, Invalid, sourceSubscriberContext)
    end for
  end sub, observables)
end function
