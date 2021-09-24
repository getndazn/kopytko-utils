' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework
' @import /components/getProperty.brs

' @returns {Mock}
function DateTime() as Object
  isReturnValueMocked = (getProperty(m.__mocks, ["dateTime", "returnValue"]) <> Invalid)
  isGetReturnValueMocked = (getProperty(m.__mocks, ["dateTime", "getReturnValue"]) <> Invalid)

  ' If we want to mock the whole DateTime object, i.e. use specific roDateTime instance
  ' when DateTime function is called, then we have to assign it to the mock's return value
  ' This condition is to detect that case, and used given roDateTime instance instead of
  ' mocking each function of a roDateTime object (with the object mock below).
  ' It's done this way because current mocking mechanism works this way that manunal mock
  ' is used when it exists for a file, and there is no way to go back and use auto mock.
  if (isReturnValueMocked OR isGetReturnValueMocked)
    return Mock({
      testComponent: m,
      name: "DateTime",
    })
  end if

  return Mock({
    testComponent: m,
    name: "DateTime",
    methods: {
      asSeconds: function () as Integer
        return m.asSecondsMock("asSeconds", {})
      end function,
      toISOString: function () as String
        return m.toISOStringMock("toISOString", {})
      end function,
    },
  })
end function
