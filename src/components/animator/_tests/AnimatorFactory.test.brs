' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/rokuComponents/Animation.brs
' @mock /components/rokuComponents/FloatFieldInterpolator.brs
' @mock /components/rokuComponents/Vector2DFieldInterpolator.brs
function TestSuite__AnimatorFactory() as Object
  ts = KopytkoTestSuite()
  ts.name = "AnimatorFactory"

  ts.setBeforeEach(sub (ts as Object)
    m.__animatorFactory = AnimatorFactory()
  end sub)

  ts.addTest("it creates animation object with given config", function (ts as Object) as String
    ' Given
    options = {
      delay: Csng(0.2),
      duration: Csng(20),
      easeFunction: "linear",
      easeInPercent: 0.1,
      easeOutPercent: 0.2,
      optional: false,
      repeat: true,
    }

    ' When
    _animation = m.__animatorFactory.createAnimation("testElement", options)

    ' Then
    expectedConfig = {
      id: "testElement",
      delay: options.delay,
      duration: options.duration,
      easeFunction: options.easeFunction,
      easeInPercent: options.easeInPercent,
      easeOutPercent: options.easeOutPercent,
      optional: options.optional,
      repeat: options.repeat,
    }
    constructedConfig = {
      id: _animation.id,
      delay: Csng(_animation.delay),
      duration: Csng(_animation.duration),
      easeFunction: _animation.easeFunction,
      easeInPercent: _animation.easeInPercent,
      easeOutPercent: _animation.easeOutPercent,
      optional: _animation.optional,
      repeat: _animation.repeat,
    }

    return ts.assertEqual(constructedConfig, expectedConfig, "Animation config is wrong")
  end function)

  ts.addTest("it creates interpolator from a node", function (ts as Object) as String
    ' Given
    options = {
      delay: Csng(0.2),
      duration: Csng(20),
      easeFunction: "linear",
      fields: [
        {
          field: "opacity",
          key: [0.0, 1.0],
          keyValue: [0.0, 1.0],
          type: "float",
        },
      ],
    }
    element = CreateObject("roSGNode", "Node")
    element.id = "myElement"

    ' When
    _animation = m.__animatorFactory.createAnimation("testElement", options, element)

    ' Then
    expectedIds = {
      animationId: "testElement",
      fieldToInterp: "myElement.opacity",
    }
    constructedIds = {
      animationId: _animation.id,
      fieldToInterp: _animation.getChild(0).fieldToInterp,
    }

    return ts.assertEqual(constructedIds, expectedIds, "Interpolator config is wrong")
  end function)

  ts.addParameterizedTests([
    { field: "opacity", key: [0.0, 1.0], keyValue: [0.0, 1.0], type: "float" },
    { field: "translation", key: [0.0, 1.0], keyValue: [[0.0, 200.0], [400.0, 1200.0]], type: "vector2d" },
  ], "it appends supported ${type} interpolator", function (ts as Object, params as Object) as String
    ' Given
    options = {
      fields: [params],
    }

    ' When
    _animation = m.__animatorFactory.createAnimation("testElement", options)

    ' Then
    interpolator = _animation.getChild(0)
    expectedInterpolatorFields = {
      fieldToInterp: "testElement." + params.field,
      id: params.field,
      key: params.key,
      keyValue: params.keyValue,
      reverse: false,
    }
    constructedInterpolatorFields = {
      fieldToInterp: interpolator.fieldToInterp,
      id: interpolator.id,
      key: interpolator.key,
      keyValue: interpolator.keyValue,
      reverse: interpolator.reverse,
    }

    return ts.assertEqual(constructedInterpolatorFields, expectedInterpolatorFields, "The interpolator has no expected config")
  end function)

  ts.addTest("it creates two interpolators", function (ts as Object) as String
    ' Given
    options = {
      delay: Csng(0.2),
      duration: Csng(20),
      easeFunction: "linear",
      fields: [
        {
          field: "opacity",
          key: [0.0, 1.0],
          keyValue: [0.0, 1.0],
          type: "float",
        },
        {
          field: "translation",
          key: [0.0, 1.0],
          keyValue: [[10, 20], [30.0, 50.0]],
          type: "vector2d",
        },
      ],
    }
    ' When
    _animation = m.__animatorFactory.createAnimation("testElement", options)

    ' Then

    return ts.assertEqual(2, _animation.getChildCount(), "There is no two interpolators")
  end function)

  return ts
end function
