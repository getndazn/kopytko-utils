' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function Timespan() as Object
  return Mock({
    testComponent: m,
    name: "Timespan",
    methods: {
      mark: sub ()
        m.markMock("mark")
      end sub,
      totalMilliseconds: function () as Integer
        return m.totalMillisecondsMock("totalMilliseconds", {}, "Integer")
      end function,
      totalSeconds: function () as Integer
        return m.totalSecondsMock("totalSeconds", {}, "Integer")
      end function,
      getSecondsToISO8601Date: function (date as String) as Integer
        return m.getSecondsToISO8601DateMock("getSecondsToISO8601Date", { date: date }, "Integer")
      end function,
    },
  })
end function
