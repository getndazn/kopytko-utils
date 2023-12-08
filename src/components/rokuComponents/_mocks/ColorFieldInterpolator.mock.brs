' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework

' @returns {Mock}
function ColorFieldInterpolator() as Object
  return Mock({
    testComponent: m,
    name: "ColorFieldInterpolator",
    fields: {
      fieldToInterp: "",
      key: [],
      keyValue: [],
      fraction: 0.0,
      reverse: false,
      __subtype: "ColorFieldInterpolator",
    },
  })
end function
