' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function FloatFieldInterpolator() as Object
  return Mock({
    testComponent: m,
    name: "FloatFieldInterpolator",
    fields: {
      fieldToInterp: "",
      key: [],
      keyValue: [],
      fraction: 0.0,
      reverse: false,
      __subtype: "FloatFieldInterpolator",
    },
  })
end function
