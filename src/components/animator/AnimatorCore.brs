' @import /components/getProperty.brs
' @import /components/promise/Promise.brs
' @import /components/promise/PromiseReject.brs
' @import /components/rokuComponents/Animation.brs
' @import /components/rokuComponents/FloatFieldInterpolator.brs
' @import /components/rokuComponents/Vector2DFieldInterpolator.brs

' The base animator class. It supports starting/stopping various animations supported by FloatFieldInterpolator or Vector2DFieldInterpolator.
' @class
function AnimatorCore() as Object
  prototype = {}

  ' @private
  prototype._contexts = {}

  ' @constructor
  ' @param {Object} m - The class instance.
  ' @param {Object} componentContext - The component's scope (parent to the instance).
  _constructor = function (m as Object, componentContext as Object) as Object
    if (componentContext["$$animatorContexts"] = Invalid)
      componentContext["$$animatorContexts"] = {}
    end if

    m._contexts = componentContext["$$animatorContexts"]

    return m
  end function

  ' Generic animate function. Can be used to animate any property supported by FloatFieldInterpolator or Vector2DFieldInterpolator.
  ' @param {Node} element
  ' @param {Object} [options={}]
  ' @param {String} options.field
  ' @param {Float} options.delay
  ' @param {Float} options.duration
  ' @param {String} options.easeFunction
  ' @param {Float[]} options.key
  ' @param {Float[]} options.keyValue
  ' @param {Boolean} options.reverse
  ' @returns {Promise} - Promise resolves when animation is finished. Rejects when there is an active animation and new one is set for the same property.
  prototype.animate = function (element as Object, options = {} as Object) as Object
    if (element = Invalid OR options.keyValue = Invalid)
      return PromiseReject("Wrong parameter")
    end if

    contextName = m._getContextName(element.id, options.field)
    m._clearContext(contextName)

    _animation = m._createAnimation(contextName, element, options)
    m._contexts[contextName] = {
      animation: _animation,
      promise: Promise(),
    }

    _animation.control = "start"

    return m._contexts[contextName].promise
  end function

  ' Finishes all the active animations for a given node.
  ' @param {Node} element
  prototype.finishAll = sub (element as Object)
    m._updateAllAnimationsFor(element, "finish")
  end sub

  ' Stops all the active animations for a given node. The difference from finishAll method is that the node keeps
  ' the current state of props when animation is stopped.
  ' @param {Node} element
  prototype.stopAll = sub (element as Object)
    m._updateAllAnimationsFor(element, "stop")
  end sub

  ' Removes all active animations without stopping them.
  prototype.destroy = sub ()
    for each animationName in m._contexts
      m._contexts[animationName].animation.unobserveFieldScoped("state")
    end for

    m._contexts.clear()
  end sub

  ' @private
  prototype._getContextName = function (elementId as String, animationType as String) as String
    return elementId + "." + animationType
  end function

  ' @private
  prototype._clearContext = sub (name as String)
    context = m._contexts[name]
    if (context = Invalid) then return

    context.animation.unobserveFieldScoped("state")
    context.animation.control = "stop"
    context.promise.reject("aborted")

    m._contexts.delete(name)
  end sub

  ' @private
  prototype._createAnimation = function (name as String, element as Object, options = {} as Object) as Object
    _animation = Animation()
    _animation.setFields({
      id: name,
      delay: getProperty(options, "delay", 0.001),
      duration: getProperty(options, "duration", 0.5),
      easeFunction: getProperty(options, "easeFunction", "outExpo"),
      optional: true,
    })
    _animation.observeFieldScoped("state", "AnimatorCore_onAnimationStateChanged")

    interpolator = m._createInterpolator(element, options)
    if (interpolator <> Invalid)
      _animation.insertChild(interpolator, 0)
    end if

    return _animation
  end function

  ' @private
  prototype._createInterpolator = function (element as Object, options as Object) as Object
    elementFieldTypes = element.getFieldTypes()
    fieldName = options.field

    if (elementFieldTypes[fieldName] = "float")
      interpolator = FloatFieldInterpolator()
    else if (elementFieldTypes[fieldName] = "vector2d")
      interpolator = Vector2DFieldInterpolator()
    else
      print "Field ";fieldName;" cannot be animated. Unsupported type of a field."

      return Invalid
    end if

    interpolator.fieldToInterp = "" ' Prevents animations not being applied sometimes
    interpolator.fieldToInterp = element.id + "." + fieldName

    interpolator.key = getProperty(options, "key", [0, 1])
    interpolator.keyValue = options.keyValue
    interpolator.reverse = getProperty(options, "reverse", false)

    return interpolator
  end function

  ' @private
  prototype._updateAllAnimationsFor = sub (element as Object, control as String)
    for each name in m._contexts
      if (name.split(".")[0] = element.id)
        m._contexts[name].animation.control = control
      end if
    end for
  end sub

  return _constructor(prototype, m)
end function

' @private
sub AnimatorCore_onAnimationStateChanged(event as Object)
  state = event.getData()
  if (state = "stopped")
    contextName = event.getNode()

    m["$$animatorContexts"][contextName].promise.resolve("stopped")
    m["$$animatorContexts"].delete(contextName)
  end if
end sub
