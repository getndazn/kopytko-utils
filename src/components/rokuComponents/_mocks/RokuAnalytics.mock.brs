' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework

' @returns {Mock}
function RokuAnalytics() as Object
  return Mock({
    testComponent: m,
    name: "RokuAnalytics",
    fields: {
      init: {},
      trackEvent: {},
    },
  })
end function
