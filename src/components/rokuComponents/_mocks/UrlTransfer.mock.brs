' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework

' @returns {Mock}
function UrlTransfer() as Object
  return Mock({
    testComponent: m,
    name: "UrlTransfer",
    methods: {
      asyncGetToString: sub ()
        m.asyncGetToStringMock("asyncGetToString")
      end sub,
      asyncPostFromString: sub (body as String)
        m.asyncPostFromStringMock("asyncPostFromString", { body: body })
      end sub,
      asyncCancel: sub ()
        m.asyncCancelMock("asyncCancel")
      end sub,
      enableEncodings: function (enable as Boolean) as Boolean
        return m.enableEncodingsMock("enableEncodings", { enable: enable }, "Boolean")
      end function,
      initClientCertificates: function (path as String) as Boolean
        return m.initClientCertificatesMock("initClientCertificates", { path: path }, "Boolean")
      end function,
      retainBodyOnError: function (retail as Boolean) as Boolean
        return m.retainBodyOnErrorMock("retainBodyOnError", { retail: retail }, "Boolean")
      end function,
      setCertificatesFile: function (path as String) as Boolean
        return m.setCertificatesFileMock("setCertificatesFile", { path: path }, "Boolean")
      end function,
      setHeaders: function (nameValueMap as Object) as Boolean
        return m.setHeadersMock("setHeaders", { nameValueMap: nameValueMap }, "Boolean")
      end function,
      setRequest: sub (request as String)
        m.setRequestMock("setRequest", { request: request })
      end sub,
      setUrl: sub (url as String)
        m.setUrlMock("setUrl", { url: url })
      end sub,
    },
  })
end function
