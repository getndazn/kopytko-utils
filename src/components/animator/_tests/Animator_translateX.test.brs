function TestSuite__Animator_translateX()
  ts = AnimatorTestSuite()
  ts.name = "Animator - translateX"

  ts.addTest("it animates first element of translation field with given options", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.translation = [123, 456]
    options = { duration: 2, easeFunction: "fancy ease function", translation: 666.0 }

    ' When
    m.__animator.translateX(element, options)

    ' Then
    expectedParams = {
      element: element,
      options: {
        duration: 2,
        easeFunction: "fancy ease function",
        field: "translation",
        keyValue: [[123.0, 456.0], [666.0, 456.0]],
      },
    }

    return ts.assertMethodWasCalled("AnimatorCore.animate", expectedParams)
  end function)

  ts.addTest("it does not crash when passing an invalid element", function (ts as Object) as String
    ' Given
    element = Invalid

    ' When
    m.__animator.translateX(element, { translation: [666, 999] })

    ' Then
    return ts.assertTrue(true)
  end function)

  return ts
end function
