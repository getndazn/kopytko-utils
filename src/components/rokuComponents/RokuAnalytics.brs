' Wrapper function for creating native Roku_Analytics:AnalyticsNode component.
' @class
function RokuAnalytics() as Object
  return CreateObject("roSGNode", "Roku_Analytics:AnalyticsNode")
end function
