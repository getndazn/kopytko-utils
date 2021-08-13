' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function Vector2DFieldInterpolator() as Object
  return Mock({
    testComponent: m,
    name: "Vector2DFieldInterpolator",
    fields: {
      fieldToInterp: "",
      key: [],
      keyValue: [],
      fraction: 0.0,
      reverse: false,
      __subtype: "Vector2DFieldInterpolator",
    },
  })
end function
