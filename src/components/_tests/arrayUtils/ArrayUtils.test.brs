' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework

function ArrayUtilsTestSuite() as Object
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    ts.__arrayUtils = ArrayUtils()
  end sub)

  return ts
end function
