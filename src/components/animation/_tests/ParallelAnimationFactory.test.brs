' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/rokuComponents/Animation.brs
' @mock /components/animator/AnimatorFactory.brs
function TestSuite__ParallelAnimationFactory() as Object
  ts = KopytkoTestSuite()
  ts.name = "ParallelAnimatorFactory"

  ts.setBeforeEach(sub (ts as Object)
    m.__parallelAnimationFactory = ParallelAnimationFactory()

    m.__mocks.animatorFactory = {
      returnValue: Animation(),
    }
  end sub)

  ts.addTest("it creates animation object with given config", function (ts as Object) as String
    ' Given
    options = {
      delay: Csng(0.2),
      repeat: true,
      animations: {
        elementOne: {
          delay: Csng(0.2),
          duration: Csng(20),
          easeFunction: "linear",
          easeInPercent: 0.1,
          easeOutPercent: 0.2,
          optional: false,
          repeat: false,
        },
      },
    }

    ' When
    _animation = m.__parallelAnimationFactory.createAnimation("testElement", options)

    ' Then
    expectedConfig = {
      id: "testElement",
      delay: options.delay,
      repeat: options.repeat,
      type: "ParallelAnimation",
    }
    constructedConfig = {
      id: _animation.id,
      delay: Csng(_animation.delay),
      repeat: _animation.repeat,
      type: _animation.subType(),
    }

    return ts.assertEqual(expectedConfig, constructedConfig, "Animation config is wrong")
  end function)

  ts.addTest("it creates child animation object", function (ts as Object) as String
    ' Given
    options = {
      delay: Csng(0.2),
      repeat: true,
      animations: {
        elementOne: {
          delay: Csng(0.2),
          duration: Csng(20),
          easeFunction: "linear",
          easeInPercent: 0.1,
          easeOutPercent: 0.2,
          optional: false,
          repeat: false,
        },
      },
    }

    ' When
    _animation = m.__parallelAnimationFactory.createAnimation("testElement", options)

    ' Then
    expectedConfig = {
      element: invalid,
      name: "elementone",
      options: {
        delay: options.animations.elementOne.delay,
        duration: options.animations.elementOne.duration,
        easeFunction: options.animations.elementOne.easeFunction,
        easeInPercent: options.animations.elementOne.easeInPercent,
        easeOutPercent: options.animations.elementOne.easeOutPercent,
        optional: options.animations.elementOne.optional,
        repeat: options.animations.elementOne.repeat,
      },
    }

    return ts.assertMethodWasCalled("AnimatorFactory.createAnimation", expectedConfig)
  end function)

  return ts
end function
