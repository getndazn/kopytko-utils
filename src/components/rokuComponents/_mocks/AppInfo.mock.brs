' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function AppInfo() as Object
  return Mock({
    testComponent: m,
    name: "AppInfo",
    methods: {
      getId: function () as String
        return m.getIdMock("getId", {})
      end function,
      getTitle: function () as String
        return m.getTitleMock("getTitle", {})
      end function,
      getValue: function (key as String) as Object
        return m.getValueMock("getValue", { key: key })
      end function,
    },
  })
end function
