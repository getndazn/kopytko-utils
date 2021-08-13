function TestSuite__AnimatorCore_finishAll()
  ts = AnimatorCoreTestSuite()
  ts.name = "AnimatorCore - finishAll"

  ts.addTest("it finishes all element animations", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    m.__animator.animate(element, { duration: 5, field: "opacity", keyValue: [0, 1] })
    m.__animator.animate(element, { duration: 5, field: "translation", keyValue: [[0, 0], [1, 1]] })

    ' When
    m.__animator.finishAll(element)

    ' Then
    opacityAnimation = __getElementAnimation("testElement.opacity")
    translationAnimation = __getElementAnimation("testElement.translation")
    expected = {
      opacityControl: "finish",
      translationControl: "finish",
    }
    actual = {
      opacityControl: opacityAnimation.control,
      translationControl: translationAnimation.control,
    }

    return ts.assertEqual(actual, expected)
  end function)

  return ts
end function
