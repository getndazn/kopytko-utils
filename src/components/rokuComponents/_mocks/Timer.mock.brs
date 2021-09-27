' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework

' @returns {Mock}
function Timer() as Object
  mockedTimer = Mock({
    testComponent: m,
    name: "Timer",
    fields: {
      id: "",
      control: "",
      duration: 0.0,
      fire: "",
      nextCall: 0.0, ' required for fakeClock
      repeat: false,
    },
  })

  mockedTimer.observeFieldScoped("duration", "TimerMock_onDurationUpdated")

  return mockedTimer
end function

' @private
sub TimerMock_onDurationUpdated(event as Object)
  duration = event.getData()
  mockedTimer = event.getRoSGNode()
  mockedTimer.nextCall = m.__currentTime + duration
end sub
