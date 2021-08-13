function TestSuite__Animator_stopAll()
  ts = AnimatorTestSuite()
  ts.name = "Animator - stopAll"

  ts.addTest("it calls AnimatorCore.stopAll with given params", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"

    ' When
    m.__animator.stopAll(element)

    ' Then
    expectedParams = {
      element: element,
    }

    return ts.assertMethodWasCalled("AnimatorCore.stopAll", expectedParams)
  end function)

  return ts
end function
