' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework

' @returns {Mock}
function HttpAgent() as Object
  return Mock({
    testComponent: m,
    name: "HttpAgent",
    methods: {
      addHeader: function (name as String, value as String) as Boolean
        return m.addHeaderMock("addHeader", { name: name, value: value })
      end function,
      setHeaders: function (headers as Object) as Boolean
        return m.setHeadersMock("setHeaders", { headers: headers })
      end function,
      initClientCertificates: function () as Boolean
        return m.initClientCertificatesMock("initClientCertificates")
      end function,
      setCertificatesFile: function (path as String) as Boolean
        return m.setCertificatesFileMock("setCertificatesFile", { path: path })
      end function,
      setCertificatesDepth: sub (depth as Integer)
        m.setCertificatesDepthMock("setCertificatesDepth", { depth: depth })
      end sub,
      enableCookies: sub ()
        m.enableCookiesMock("enableCookies")
      end sub,
      getCookies: function (domain as String, path as String) as Object
        return m.getCookiesMock("getCookies", { domain: domain, path: path })
      end function,
      addCookies: function (cookies as Object) as Boolean
        return m.addCookiesMock("addCookies", { cookies: cookies })
      end function,
      clearCookies: sub ()
        m.clearCookiesMock("clearCookies")
      end sub,
    },
  })
end function
