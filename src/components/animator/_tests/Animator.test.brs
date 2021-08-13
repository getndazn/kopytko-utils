' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
' @mock pkg:/components/animator/AnimatorCore.brs
function AnimatorTestSuite() as Object
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    m.__animator = Animator()

    m.__mocks = {}
    m.__mocks.animatorCore = {}
  end sub)

  return ts
end function
