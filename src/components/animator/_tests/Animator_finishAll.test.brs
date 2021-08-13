function TestSuite__Animator_finishAll()
  ts = AnimatorTestSuite()
  ts.name = "Animator - finishAll"

  ts.addTest("it calls AnimatorCore.finishAll with given params", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"

    ' When
    m.__animator.finishAll(element)

    ' Then
    expectedParams = {
      element: element,
    }

    return ts.assertMethodWasCalled("AnimatorCore.finishAll", expectedParams)
  end function)

  return ts
end function
