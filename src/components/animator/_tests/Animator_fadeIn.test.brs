function TestSuite__Animator_fadeIn()
  ts = AnimatorTestSuite()
  ts.name = "Animator - fadeIn"

  ts.addTest("it animates opacity field from current value to 1 with given options", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.opacity = 0.5
    options = { duration: 2, easeFunction: "fancy ease function" }

    ' When
    m.__animator.fadeIn(element, options)

    ' Then
    expectedParams = {
      element: element,
      options: {
        duration: 2,
        easeFunction: "fancy ease function",
        field: "opacity",
        keyValue: [0.5, 1],
      },
    }

    return ts.assertMethodWasCalled("AnimatorCore.animate", expectedParams)
  end function)

  ts.addTest("it does not crash when passing an invalid element", function (ts as Object) as String
    ' Given
    element = Invalid

    ' When
    m.__animator.fadeIn(element)

    ' Then
    return ts.assertTrue(true)
  end function)

  return ts
end function
