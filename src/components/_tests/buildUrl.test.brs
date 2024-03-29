' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function TestSuite__buildUrl() as Object
  ts = KopytkoTestSuite()
  ts.name = "buildUrl"

  ts.addTest("returns path if no params provided", function (ts as Object) as String
    ' Given
    path = "/example-path"

    ' When
    result = buildUrl(path)

    ' Then
    return ts.assertEqual(result, path)
  end function)

  ts.addTest("returns path if params is an empty AA", function (ts as Object) as String
    ' Given
    path = "/example-path"
    params = {}

    ' When
    result = buildUrl(path, params)

    ' Then
    return ts.assertEqual(result, path)
  end function)

  ts.addTest("returns the proper URL for simple single param", function (ts as Object) as String
    ' Given
    path = "/example-path"
    params = { parameter: "valueOne" }
    expectedUrl = "/example-path?parameter=valueOne"

    ' When
    result = buildUrl(path, params)

    ' Then
    return ts.assertEqual(result, expectedUrl)
  end function)

  ts.addTest("returns the proper URL for multiple params", function (ts as Object) as String
    ' Given
    path = "/example-path"
    params = { paramOne: "valueOne", paramTwo: 2, paramThree: false }
    expectedUrl = "/example-path?paramone=valueOne&paramthree=false&paramtwo=2"

    ' When
    result = buildUrl(path, params)

    ' Then
    return ts.assertEqual(result, expectedUrl)
  end function)

  ts.addTest("returns URL with encoded space sign", function (ts as Object) as String
    ' Given
    path = "http://roku.com/my test.html?john= doe"
    params = { parameter: "value One" }
    expectedUrl = "http://roku.com/my%20test.html?john=%20doe&parameter=value%20One"

    ' When
    result = buildUrl(path, params)

    ' Then
    return ts.assertEqual(result, expectedUrl)
  end function)

  ts.addTest("returns proper url even when path was encoded", function (ts as Object) as String
    ' Given
    path = "http://roku.com/my%20test.html?john=%20doe"
    params = { parameter: "value One" }
    expectedUrl = "http://roku.com/my%20test.html?john=%20doe&parameter=value%20One"

    ' When
    result = buildUrl(path, params)

    ' Then
    return ts.assertEqual(result, expectedUrl)
  end function)

  ts.addTest("ignores parameters that can't be converted to non-empty string", function (ts as Object) as String
    ' Given
    path = "/example-path"
    params = { param1: "", param2: ["p2"], param3: { p3: "p3"}, param4: CreateObject("roSGNode", "Node"), param5: invalid }
    expectedUrl = "/example-path"

    ' When
    result = buildUrl(path, params)

    ' Then
    return ts.assertEqual(result, expectedUrl)
  end function)

  return ts
end function
