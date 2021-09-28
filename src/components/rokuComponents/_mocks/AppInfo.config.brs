' Config for AppInfo mock.
' @param {Object} [getValueData={}] - The manifest data that is retrieved by getValue method.
' @returns {Object}
function getAppInfoMockConfig(getValueData = {} as Object) as Object
  return {
    getId: {
      calls: [],
      returnValue: "",
    },
    getTitle: {
      calls: [],
      returnValue: "",
    },
    getValue: {
      calls: [],
      getReturnValue: function (params as Object, m as Object) as Object
        for each key in m.__mocks.appInfo.getValue.data
          if (LCase(params.key) = LCase(key))
            return m.__mocks.appInfo.getValue.data[key]
          end if
        end for

        return Invalid
      end function,
      data: getValueData,
    },
  }
end function
