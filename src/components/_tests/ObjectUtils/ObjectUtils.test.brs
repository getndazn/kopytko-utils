' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function ObjectUtilsTestSuite()
  ts = KopytkoTestSuite()

  ts.setBeforeEach(sub (ts as Object)
    ts.__objectUtils = ObjectUtils()
  end sub)

  return ts
end function
