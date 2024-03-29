' @import /components/animator/AnimatorFactory.brs
' @import /components/promise/Promise.brs
' @import /components/promise/PromiseReject.brs

' The base animator class. It supports starting/stopping various animations supported by FloatFieldInterpolator or Vector2DFieldInterpolator.
' @class
function AnimatorCore() as Object
  prototype = {}

  ' @private
  prototype._animatorFactory = AnimatorFactory()

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
    if (element = Invalid OR options.field = Invalid OR options.keyValue = Invalid)
      return PromiseReject("Wrong animate parameter")
    end if

    contextName = m._getContextName(element.id, options.field)
    m._clearContext(contextName)

    _animation = m._animatorFactory.createAnimation(contextName, m._prepareOptions(options, element), element)
    _animation.observeFieldScoped("state", "AnimatorCore_onAnimationStateChanged")

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
    context.animation.control = "finish"
    context.promise.reject("aborted")

    m._contexts.delete(name)
  end sub

  ' @private
  prototype._updateAllAnimationsFor = sub (element as Object, control as String)
    for each name in m._contexts
      if (name.split(".")[0] = element.id)
        m._contexts[name].animation.control = control
      end if
    end for
  end sub

  ' @private
  prototype._prepareOptions = function (options as Object, element as Object) as Object
    field = options.field

    return {
      delay: options.delay,
      duration: options.duration,
      easeFunction: options.easeFunction,
      fields: [
        {
          field: field,
          key: options.key,
          keyValue: options.keyValue,
          reverse: options.reverse,
          type: element.getFieldTypes()[field],
        }
      ],
    }
  end function

  return _constructor(prototype, m)
end function

' @private
sub AnimatorCore_onAnimationStateChanged(event as Object)
  state = event.getData()
  if (state = "stopped")
    contextName = event.getNode()

    if (NOT m["$$animatorContexts"].doesExist(contextName)) then return

    context = m["$$animatorContexts"][contextName]
    m["$$animatorContexts"].delete(contextName)
    context.promise.resolve("stopped")
  end if
end sub
