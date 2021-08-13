function TestSuite__Animator_animate()
  ts = AnimatorTestSuite()
  ts.name = "Animator - animate"

  ts.addTest("it calls AnimatorCore.animate with given params", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    options = {
      duration: 2,
      easeFunction: "fancy ease function",
      field: "opacity",
      keyValue: [0, 1],
    }

    ' When
    m.__animator.animate(element, options)

    ' Then
    expectedParams = {
      element: element,
      options: options,
    }

    return ts.assertMethodWasCalled("AnimatorCore.animate", expectedParams)
  end function)

  return ts
end function
