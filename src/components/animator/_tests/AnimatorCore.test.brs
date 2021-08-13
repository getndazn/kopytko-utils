' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
' @import /components/rokuComponents/_mocks/Event.mock.brs
' @mock /components/rokuComponents/Animation.brs
' @mock /components/rokuComponents/FloatFieldInterpolator.brs
' @mock /components/rokuComponents/Vector2DFieldInterpolator.brs
function AnimatorCoreTestSuite() as Object
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    m.__animator = AnimatorCore()
  end sub)

  ts.setAfterEach(sub (ts as Object)
    m.__animator.destroy()
    m.delete("$$animatorContexts")
  end sub)

  return ts
end function

function __getElementAnimation(contextName as String) as Object
  return getProperty(m.__animator._contexts, [contextName, "animation"])
end function

function __getElementInterpolator(contextName as String) as Object
  _animation = __getElementAnimation(contextName)
  if (_animation = Invalid) then return Invalid

  return _animation.getChild(0)
end function
