function TestSuite__Animator_fade()
  ts = AnimatorTestSuite()
  ts.name = "Animator - fade"

  ts.addTest("it animates opacity field with given options", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    options = { duration: 2, easeFunction: "fancy ease function", keyValue: [0, 0.5] }

    ' When
    m.__animator.fade(element, options)

    ' Then
    expectedParams = {
      element: element,
      options: {
        duration: 2,
        easeFunction: "fancy ease function",
        field: "opacity",
        keyValue: [0, 0.5],
      },
    }

    return ts.assertMethodWasCalled("AnimatorCore.animate", expectedParams)
  end function)

  ts.addTest("it does not crash when passing an invalid element", function (ts as Object) as String
    ' Given
    element = Invalid

    ' When
    m.__animator.fade(element, { keyValue: [0, 1] })

    ' Then
    return ts.assertTrue(true)
  end function)

  return ts
end function
