' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework
' @import /components/createNode.brs
' @import /components/getProperty.brs
' @import /components/getType.brs

' @returns {Mock}
function GlobalNode() as Object
  fields = {
    cache: createNode(),
    convivaService: createNode(),
    daznDialog: createNode(),
    deepLinkEventId: "",
    deviceInfo: createNode(),
    eventBus: createNode(),
    entitlementService: createNode(),
    launchSource: "",
    railRequestsPool: [],
    rokuAnalytics: createNode(),
    router: createNode(),
    spinner: createNode(),
    store: createNode(),
    theme: createNode(),
  }

  mockedFields = getProperty(m.__mocks, ["globalNode"], {})

  for each key in fields.keys()
    if (mockedFields.doesExist(key))
      mockedField = mockedFields[key]

      if (getType(fields[key]) = "roSGNode" AND getType(mockedField) = "roAssociativeArray")
        fields[key].addFields(mockedField)
      else
        fields[key] = mockedField
      end if
    end if
  end for

  return Mock({
    testComponent: m,
    name: "globalNode",
    fields: fields,
  })
end function
