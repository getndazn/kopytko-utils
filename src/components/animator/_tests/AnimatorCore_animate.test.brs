function TestSuite__AnimatorCore_animate()
  ts = AnimatorCoreTestSuite()
  ts.name = "AnimatorCore - animate"

  ts.addParameterizedTests([
    { keyValue: [0, 1], type: "float" },
    { keyValue: [[0, 0], [1, 1]], type: "vector2d" },
  ], "it creates an animation with proper name for ${type} field of the element to be animated", function (ts as Object, params as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.addField("animatedField", params.type, false)

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: params.keyValue })

    ' Then
    animation = __getElementAnimation("testElement.animatedField")

    return ts.assertNotInvalid(animation, "The animation was not created or was created with a wrong name")
  end function)

  ts.addTest("it does not crash when passing an invalid element", function (ts as Object) as String
    ' Given
    element = Invalid

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1] })

    ' Then
    return ts.assertTrue(true)
  end function)

  ts.addParameterizedTests([
    { keyValue: [0, 1], type: "float", interpolatorType: "FloatFieldInterpolator" },
    { keyValue: [[0, 0], [1, 1]], type: "vector2d", interpolatorType: "Vector2DFieldInterpolator" },
    { keyValue: [[0, 0], [1, 1]], type: "string", interpolatorType: "Invalid" },
  ],"it creates ${interpolatorType} interpolator for ${type} field type", function (ts as Object, params as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.addField("animatedField", params.type, false)

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: params.keyValue })

    ' Then
    interpolator = __getElementInterpolator("testElement.animatedField")
    if (params.interpolatorType = "Invalid")
      return ts.assertInvalid(interpolator)
    end if

    if (interpolator = Invalid)
      return ts.fail("The interpolator was not created")
    end if

    return ts.assertEqual(interpolator.__subtype, params.interpolatorType, "The interpolator was created with a wrong type")
  end function)

  ts.addParameterizedTests([
    { keyValue: [0, 1], type: "float" },
    { keyValue: [[0, 0], [1, 1]], type: "vector2d" },
  ], "it sets all passed params to the animation element created for ${type} field", function (ts as Object, params as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.addField("animatedField", params.type, false)

    ' When
    m.__animator.animate(element, {
      duration: 2,
      easeFunction: "fancy ease function",
      field: "animatedField",
      keyValue: params.keyValue,
    })

    ' Then
    expectedFields = {
      duration: 2,
      easeFunction: "fancy ease function",
      field: "animatedField",
      keyValue: params.keyValue,
      optional: true,
    }

    animation = __getElementAnimation("testElement.animatedField")
    actualFields = {
      duration: animation.duration,
      easeFunction: animation.easeFunction,
      keyValue: animation.keyValue,
      optional: animation.optional,
    }

    return ts.assertEqual(actualFields, actualFields, "The fields were not set correctly")
  end function)

  ts.addParameterizedTests([
    { keyValue: [0.666, 0.999], type: "float" },
    { keyValue: [[0, 0], [0.666, 0.999]], type: "vector2d" },
  ], "it sets the proper fields in the interpolator element created for ${type} field", function (ts as Object, params as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.addField("animatedField", params.type, false)

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: params.keyValue })

    ' Then
    expectedFields = {
      fieldToInterp: "testElement.animatedField",
      key: [0, 1],
      keyValue: params.keyValue,
    }

    interpolator = __getElementInterpolator("testElement.animatedField")
    actualFields = {
      fieldToInterp: interpolator.fieldToInterp,
      key: interpolator.key,
      keyValue: interpolator.keyValue,
    }

    return ts.assertEqual(actualFields, actualFields, "The fields were not set correctly")
  end function)

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

  ts.addTest("it stops pending animation when trying to create the same one", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Node")
    element.id = "testElement"
    element.addField("animatedField", "float", false)

    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 })
    firstAnimation = __getElementAnimation("testElement.animatedField")

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 })

    ' Then
    return ts.assertEqual(firstAnimation.control, "stop")
  end function)

  return ts
end function
