' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/reactiveX/RxSubscriber.brs
function TestSuite__RxSubscription() as Object
  ts = KopytkoTestSuite()
  ts.name = "RxSubscription"

  ts.addTest("unsubscribe calls subscribe's unsubscribe with observable passed", function (ts as Object) as Object
    ' Given
    subscriber = RxSubscriber({}, {})
    observable = { example: "observable" }
    subscription = RxSubscription(subscriber, observable)

    ' When
    subscription.unsubscribe()

    ' Then
    return ts.assertMethodWasCalled("RxSubscriber.unsubscribe", { observable: observable })
  end function)

  return ts
end function
