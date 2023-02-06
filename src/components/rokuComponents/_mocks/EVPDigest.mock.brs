' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework

' @returns {Mock}
function EVPDigest() as Object
  return Mock({
    testComponent: m,
    name: "EVPDigest",
    methods: {
      setup: function (digestType as String) as Integer
        return m.setupMock("setup", { digestType: digestType }, "Integer")
      end function,
      reinit: function () as Integer
        return m.reinitMock("reinit", {}, "Integer")
      end function,
      process: function (bytes as Object) as String
        return m.processMock("process", { bytes: bytes }, "String")
      end function,
      update: sub (bytes as Object)
        m.updateMock("update", { bytes: bytes })
      end sub,
      final: function () as String
        return m.finalMock("final", {}, "String")
      end function,
    },
  })
end function
