' @import /components/animator/AnimatorFactory.brs
' @import /components/getProperty.brs
' @import /components/rokuComponents/ParallelAnimation.brs

' @class
function ParallelAnimationFactory() as Object
  prototype = {}

  ' Creates ParallelAnimation component with one or more Animations.
  ' @param {String} name
  ' @param {Object} [options={}]
  ' @param {Float} options.delay
  ' @param {Boolean} options.repeat
  ' @param {Object.<string, AnimatorFactory~Options>}
  ' @param {Node} element
  ' @returns {Object} - ParallelAnimation component
  prototype.createAnimation = function(name as String, options = {} as Object) as Object
    parallelAnimationNode = ParallelAnimation()
    parallelAnimationNode.setFields({
      id: name,
      delay: getProperty(options, "delay", 0.001),
      repeat: getProperty(options, "repeat", false),
    })

    factory = AnimatorFactory()
    for each animationOption in options.animations.items()
      parallelAnimationNode.appendChild(factory.createAnimation(animationOption.key, animationOption.value))
    end for

    return parallelAnimationNode
  end function

  return prototype
end function
