' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework

' @returns {Mock}
function Animation() as Object
  return Mock({
    testComponent: m,
    name: "Animation",
    fields: {
      control: "",
      delay: 0,
      duration: 0,
      easeFunction: "easeFunction",
      easeInPercent: 0.5,
      easeOutPercent: 0.5,
      id: "",
      optional: false,
      state: "",
      repeat: false,
    },
  })
end function
