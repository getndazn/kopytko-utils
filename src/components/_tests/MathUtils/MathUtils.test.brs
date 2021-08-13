' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function MathUtilsTestSuite() as Object
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    ts.__mathUtils = MathUtils()
  end sub)

  return ts
end function
