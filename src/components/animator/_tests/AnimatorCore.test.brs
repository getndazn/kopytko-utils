' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/getProperty.brs
' @mock /components/animator/AnimatorFactory.brs
' @mock /components/rokuComponents/Animation.brs
function AnimatorCoreTestSuite() as Object
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    m.__mocks = {}
    m.__mocks.animatorFactory = {
      createAnimation: {
        getReturnValue: function (params as Object, m as Object) as Object
          _animation = Animation()
          _animation.id = params.name

          return _animation
        end function,
      },
    }

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
