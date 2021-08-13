' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function MessagePort() as Object
  return Mock({
    testComponent: m,
    name: "MessagePort",
    methods: {
      waitMessage: function (timeout as Float) as Dynamic
        m.waitMessageMock("waitMessage", { timeout: timeout })

        return Invalid
      end function,
    },
  })
end function
