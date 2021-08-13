' @import /components/animator/AnimatorCore.brs
' @import /components/getProperty.brs

' Utility that helps creating and managing animations like fade, fadeIn or fadeOut.
' The class can animate any field that is supported by FloatFieldInterpolator or Vector2DFieldInterpolator.
' @example
' Animator().fadeIn(m.top.findNode("nodeToAnimate")).then(sub (state as String): ' Animation finished
' end sub)
' @class
function Animator() as Object
  prototype = {}

  ' @private
  prototype._animatorCore = AnimatorCore()

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
    return m._animatorCore.animate(element, options)
  end function

  ' Finishes all the active animations for a given node.
  ' @param {Node} element
  prototype.finishAll = sub (element as Object)
    m._animatorCore.finishAll(element)
  end sub

  ' Stops all the active animations for a given node. The difference from finishAll method is that the node keeps
  ' the current state of props when animation is stopped.
  ' @param {Node} element
  prototype.stopAll = sub (element as Object)
    m._animatorCore.stopAll(element)
  end sub

  ' Generic fade function.
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
  prototype.fade = function (element as Object, options = {} as Object) as Object
    fadeOptions = m._mergeOptions(options, { field: "opacity" })

    return m.animate(element, fadeOptions)
  end function

  ' Animates from current node's opacity value to visible state. If the node is visible it does not animate it.
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
  prototype.fadeIn = function (element as Object, options = {} as Object) as Object
    fadeOptions = m._mergeOptions(options, { keyValue: [getProperty(element, "opacity", 0), 1] })

    return m.fade(element, fadeOptions)
  end function

  ' Animates from current node's opacity value to invisible state. If the node is invisible it does not animate it.
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
  prototype.fadeOut = function (element as Object, options = {} as Object) as Object
    fadeOptions = m._mergeOptions(options, { keyValue: [getProperty(element, "opacity", 1), 0] })

    return m.fade(element, fadeOptions)
  end function

  ' Animates from current node's translation value to expected one.
  ' @param {Node} element
  ' @param {Object} [options={}]
  ' @param {Float[]} translation
  ' @param {String} options.field
  ' @param {Float} options.delay
  ' @param {Float} options.duration
  ' @param {String} options.easeFunction
  ' @param {Float[]} options.key
  ' @param {Float[]} options.keyValue
  ' @param {Boolean} options.reverse
  ' @returns {Promise} - Promise resolves when animation is finished. Rejects when there is an active animation and new one is set for the same property.
  prototype.translate = function (element as Object, options = {} as Object) as Object
    translateOptions = m._mergeOptions(options, {
      field: "translation",
      keyValue: [getProperty(element, "translation", [0, 0]), getProperty(options, "translation", [0, 0])],
    })

    return m.animate(element, translateOptions)
  end function

  ' Animates from current node's X translation value to expected one.
  ' @param {Node} element
  ' @param {Object} [options={}]
  ' @param {Float[]} translation
  ' @param {String} options.field
  ' @param {Float} options.delay
  ' @param {Float} options.duration
  ' @param {String} options.easeFunction
  ' @param {Float[]} options.key
  ' @param {Float[]} options.keyValue
  ' @param {Boolean} options.reverse
  ' @returns {Promise} - Promise resolves when animation is finished. Rejects when there is an active animation and new one is set for the same property.
  prototype.translateX = function (element as Object, options = {} as Object) as Object
    translateOptions = m._mergeOptions(options, {
      translation: [getProperty(options, "translation", 0), getProperty(element, "translation", [0, 0])[1]],
    })

    return m.translate(element, translateOptions)
  end function

  ' @private
  prototype._mergeOptions = function (options1 as Object, options2 as Object) as Object
    mergedOptions = {}
    mergedOptions.append(options1)
    mergedOptions.append(options2)

    return mergedOptions
  end function

  return prototype
end function
