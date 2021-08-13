function TestSuite__AnimatorCore_stopAll()
  ts = AnimatorCoreTestSuite()
  ts.name = "AnimatorCore - stopAll"

  ts.addTest("it stops all element animations", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    m.__animator.animate(element, { duration: 5, field: "opacity", keyValue: [0, 1] })
    m.__animator.animate(element, { duration: 5, field: "translation", keyValue: [[0, 0], [1, 1]] })

    ' When
    m.__animator.stopAll(element)

    ' Then
    opacityAnimation = __getElementAnimation("testElement.opacity")
    translationAnimation = __getElementAnimation("testElement.translation")

    expected = {
      opacityControl: "stop",
      translationControl: "stop",
    }
    actual = {
      opacityControl: opacityAnimation.control,
      translationControl: translationAnimation.control,
    }

    return ts.assertEqual(actual, expected)
  end function)

  return ts
end function
