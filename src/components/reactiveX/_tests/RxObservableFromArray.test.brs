' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
' @mock /components/reactiveX/RxSubscriber.brs
' @mock /components/reactiveX/RxSubscription.brs
function TestSuite__RxObservableFromArray() as Object
  ts = KopytkoTestSuite()
  ts.name = "RxObservableFromArray"

  ts.setBeforeEach(sub (ts as Object)
    m.__observer = { "next": "observer.next", error: "observer.error", complete: "observer.complete" }
  end sub)

  ts.addTest("should iterate over given values", function (ts as Object) as String
    ' Given
    values = [1, 2, 3]
    observable = RxObservableFromArray(values)

    ' When
    observable.subscribe(m.__observer)

    ' Then
    for i = 0 to values.count() - 1
      result = ts.assertEqual(m.__mocks.rxSubscriber.next.calls[i].params.value, values[i])

      if (result <> "")
        return result
      end if
    end for

    return ts.assertMethodWasCalled("RxSubscriber.next", {}, { times: 3 })
  end function)

  ts.addTest("should fire complete handler", function (ts as Object) as String
    ' Given
    values = [1, 2, 3]
    observable = RxObservableFromArray(values)

    ' When
    observable.subscribe(m.__observer)

    ' Then
    return ts.assertMethodWasCalled("RxSubscriber.complete")
  end function)

  return ts
end function
