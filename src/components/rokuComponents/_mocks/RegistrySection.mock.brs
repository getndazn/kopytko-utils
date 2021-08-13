' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function RegistrySection(name as String) as Object
  return Mock({
    testComponent: m,
    constructorParams: {
      name: name,
    },
    name: "RegistrySection",
    methods: {
      exists: function (key as String) as Boolean
        return m.existsMock("exists", { key: key }, "Boolean")
      end function,

      read: function (key as String) as Dynamic
        return m.readMock("read", { key: key })
      end function,

      write: function (key as String, value as String) as Boolean
        return m.writeMock("write", { key: key, value: value }, "Boolean")
      end function,

      delete: function (key as String) as Boolean
        return m.deleteMock("delete", { key: key }, "Boolean")
      end function,

      flush: function () as Boolean
        return m.flushMock("flush", {}, "Boolean")
      end function,
    },
  })
end function
