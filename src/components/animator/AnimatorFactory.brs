' @import /components/getProperty.brs
' @import /components/rokuComponents/Animation.brs
' @import /components/rokuComponents/FloatFieldInterpolator.brs
' @import /components/rokuComponents/Vector2DFieldInterpolator.brs

' @class
function AnimatorFactory() as Object
  prototype = {}

  ' Creates Animation component with one or more interpolators.
  ' @param {String} name
  ' @param {Object} [options={}]
  ' @param {Float} options.delay
  ' @param {Float} options.duration
  ' @param {String} options.easeFunction
  ' @param {Object[]} options.fields
  ' @param {String} options.fields.field
  ' @param {Integer[]} options.fields.key
  ' @param {Dynamic[]} options.fields.keyValue
  ' @param {Boolean} options.fields.reverse
  ' @param {Node} element
  ' @returns {Object} - Animation component
  prototype.createAnimation = function (name as String, options = {} as Object, element = Invalid as Object) as Object
    animationNode = Animation()
    animationNode.setFields({
      id: name,
      delay: getProperty(options, "delay", 0.001),
      duration: getProperty(options, "duration", 0.5),
      easeFunction: getProperty(options, "easeFunction", "outExpo"),
      easeInPercent: getProperty(options, "easeInPercent", 0.5),
      easeOutPercent: getProperty(options, "easeOutPercent", 0.5),
      optional: getProperty(options, "optional", true),
      repeat: getProperty(options, "repeat", false),
    })

    if (element = Invalid)
      element = { id: name }
    end if

    m._createInterpolators(animationNode, options, element)

    return animationNode
  end function

  ' @private
  prototype._createInterpolators = sub (animationNode as Object, options as Object, element as Object)
    interpolatorOptions = getProperty(options, "fields", [])

    for each fieldOptions in interpolatorOptions
      interpolator = m._createInterpolator(fieldOptions, element)
      if (interpolator <> Invalid)
        animationNode.insertChild(interpolator, 0)
      end if
    end for
  end sub

  ' @private
  prototype._createInterpolator = function (fieldOptions as Object, element as Object) as Object
    if (fieldOptions.type = "float")
      interpolator = FloatFieldInterpolator()
    else if (fieldOptions.type = "vector2d")
      interpolator = Vector2DFieldInterpolator()
    else
      print "Field ";fieldOptions.field;" cannot be animated. Unsupported type of a field."

      return Invalid
    end if

    interpolator.fieldToInterp = "" ' Prevents animations not being applied sometimes
    interpolator.fieldToInterp = element.id + "." + fieldOptions.field
    interpolator.id = fieldOptions.field

    interpolator.key = getProperty(fieldOptions, "key", [0, 1])
    interpolator.keyValue = getProperty(fieldOptions, "keyValue", [])
    interpolator.reverse = getProperty(fieldOptions, "reverse", false)

    return interpolator
  end function

  return prototype
end function
