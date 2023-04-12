function TestSuite__AnimatorCore_animate()
  ts = AnimatorCoreTestSuite()
  ts.name = "AnimatorCore - animate"

  ts.addParameterizedTests([
    { keyValue: [0, 1], type: "float" },
    { keyValue: [[0, 0], [1, 1]], type: "vector2d" },
  ], "it plays the animation of ${type} field", function (ts as Object, params as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.addField("animatedField", params.type, false)

    ' When
    m.__animator.animate(element, {
      duration: 2,
      easeFunction: "linear",
      field: "animatedField",
      keyValue: params.keyValue,
    })

    ' Then
    expected = "start"
    actual = __getElementAnimation("testElement.animatedField").control

    return ts.assertEqual(actual, expected, "The animation did not start")
  end function)

  ts.addTest("it finishes pending animation when trying to create the same one", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Node")
    element.id = "testElement"
    element.addField("animatedField", "float", false)

    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 })
    firstAnimation = __getElementAnimation("testElement.animatedField")

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 })

    ' Then
    return ts.assertEqual(firstAnimation.control, "finish")
  end function)

  return ts
end function
