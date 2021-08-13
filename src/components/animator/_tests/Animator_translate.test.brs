function TestSuite__Animator_translate()
  ts = AnimatorTestSuite()
  ts.name = "Animator - translate"

  ts.addTest("it animates translation field with given options", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.translation = [123, 456]
    options = { duration: 2, easeFunction: "fancy ease function", translation: [666.0, 999.0] }

    ' When
    m.__animator.translate(element, options)

    ' Then
    expectedParams = {
      element: element,
      options: {
        duration: 2,
        easeFunction: "fancy ease function",
        field: "translation",
        keyValue: [[123.0, 456.0], [666.0, 999.0]],
      },
    }

    return ts.assertMethodWasCalled("AnimatorCore.animate", expectedParams)
  end function)

  ts.addTest("it does not crash when passing an invalid element", function (ts as Object) as String
    ' Given
    element = Invalid

    ' When
    m.__animator.translate(element, { translation: [666, 999] })

    ' Then
    return ts.assertTrue(true)
  end function)

  return ts
end function
