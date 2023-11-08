' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/rokuComponents/Animation.brs
' @mock /components/animator/AnimatorFactory.brs
function TestSuite__ParallelAnimationFactory() as Object
  ts = KopytkoTestSuite()
  ts.name = "ParallelAnimatorFactory"

  beforeEach(sub (_ts as Object)
    mockFunction("AnimatorFactory.createAnimation").returnValue(Animation())
  end sub)

  it("creates animation object with given config", function (_ts as Object) as String
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
    _animation = ParallelAnimationFactory().createAnimation("testElement", options)

    ' Then
    constructedConfig = {
      id: _animation.id,
      delay: Csng(_animation.delay),
      repeat: _animation.repeat,
      type: _animation.subType(),
    }
    expectedConfig = {
      id: "testElement",
      delay: options.delay,
      repeat: options.repeat,
      type: "ParallelAnimation",
    }

    return expect(constructedConfig).toEqual(expectedConfig)
  end function)

  it("creates child animation object", function (_ts as Object) as String
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
          fields: [
            { field: "opacity", type: "float" }
            { field: "translation", type: "vector2d" }
          ],
        },
      },
    }

    ' When
    ParallelAnimationFactory().createAnimation("testElement", options)

    ' Then
    expectedConfig = {
      name: "elementone",
      options: {
        delay: options.animations.elementOne.delay,
        duration: options.animations.elementOne.duration,
        easeFunction: options.animations.elementOne.easeFunction,
        easeInPercent: options.animations.elementOne.easeInPercent,
        easeOutPercent: options.animations.elementOne.easeOutPercent,
        optional: options.animations.elementOne.optional,
        repeat: options.animations.elementOne.repeat,
        fields: options.animations.elementOne.fields,
        },
      }

    return expect("AnimatorFactory.createAnimation").toHaveBeenCalledWith(expectedConfig, { times: 1 })
  end function)

  it("creates 2 child animation objects", function (_ts as Object) as String
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
          fields: [
            { field: "opacity", type: "float" }
            { field: "translation", type: "vector2d" }
          ],
        },
        elementTwo: {
          delay: Csng(122),
          duration: Csng(20),
          easeFunction: "outExpo",
          easeInPercent: 0.1,
          easeOutPercent: 0.2,
          optional: false,
          repeat: false,
          fields: [
            { field: "color", type: "color" }
          ],
        },
      },
    }

    ' When
    ParallelAnimationFactory().createAnimation("testElement", options)

    ' Then
    return expect("AnimatorFactory.createAnimation").toHaveBeenCalledTimes(2)
  end function)

  return ts
end function
