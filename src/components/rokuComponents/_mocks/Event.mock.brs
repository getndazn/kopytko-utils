' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' Use this to create an event object that should be passed as parameter when directly calling event callbacks.
' @param {Object} eventScheme
' @param {Dynamic} eventScheme.data - The data that should be returned when calling getData().
' @param {String} eventScheme.field - The field that caused the callback to be triggered.
' @param {String} eventScheme.nodeId - The ID of the node that triggered the callback.
' @param {Node} eventScheme.node - The reference for the node that triggered the callback.
' @returns {Object} - The event object.
function Event(eventScheme as Object) as Object
  return Mock({
    testComponent: m,
    properties: {
      eventScheme: eventScheme,
    },
    name: "Event",
    methods: {
      getData: function () as Dynamic
        m.getDataMock("getData")

        return m.eventScheme.data
      end function,
      getField: function () as String
        m.getFieldMock("getField")

        return m.eventScheme.field
      end function,
      getNode: function () as String
        m.getNodeMock("getNode")

        if (m.eventScheme.nodeId <> Invalid)
          return m.eventScheme.nodeId
        else if (m.eventScheme.node <> Invalid AND m.eventScheme.node.id <> Invalid)
          return m.eventScheme.node.id
        end if

        return ""
      end function,
      getRoSGNode: function () as Boolean
        m.getRoSGNodeMock("getRoSGNode")

        return m.eventScheme.node
      end function,
    },
  })
end function
