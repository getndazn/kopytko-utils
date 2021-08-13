function TestSuite__AnimatorCore_promise()
  ts = AnimatorCoreTestSuite()
  ts.name = "AnimatorCore - promise"

  ts.addTest("it returns a rejected promise if passed Invalid element", function (ts as Object) as String
    ' Given
    m.__animateRejectionReason = Invalid

    ' When
    m.__animator.animate(Invalid, { field: "animatedField", keyValue: [0, 1], duration: 5 }).catch(sub (reason as String)
      m.__animateRejectionReason = reason
    end sub)

    ' Then
    return ts.assertEqual(m.__animateRejectionReason, "Wrong parameter")
  end function)

  ts.addTest("it returns a rejected promise if not passed keyValue option", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Node")
    element.id = "testElement"
    element.addField("animatedField", "float", false)
    m.__animateRejectionReason = Invalid

    ' When
    m.__animator.animate(element, { field: "animatedField", duration: 5 }).catch(sub (reason as String)
      m.__animateRejectionReason = reason
    end sub)

    ' Then
    return ts.assertEqual(m.__animateRejectionReason, "Wrong parameter")
  end function)

  ts.addTest("it resolves promise when animation is done", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Node")
    element.id = "testElement"
    element.addField("animatedField", "float", false)
    m.__animateResolution = Invalid

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 }).then(sub (status as String)
      m.__animateResolution = status
    end sub)

    _animation = __getElementAnimation("testElement.animatedField")
    _animation.state = "stopped"

    ' Then
    return ts.assertEqual(m.__animateResolution, "stopped")
  end function)

  ts.addTest("it rejects promise when animation was aborted", function (ts as Object) as String
    ' Given
    element = CreateObject("roSGNode", "Group")
    element.id = "testElement"
    element.addField("animatedField", "float", false)
    m.__animateResolution = Invalid
    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 }).catch(sub (status as String)
      m.__animateResolution = status
    end sub)

    ' When
    m.__animator.animate(element, { field: "animatedField", keyValue: [0, 1], duration: 5 })

    ' Then
    return ts.assertEqual(m.__animateResolution, "aborted")
  end function)

  return ts
end function
