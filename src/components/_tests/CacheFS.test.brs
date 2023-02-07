' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/rokuComponents/EVPDigest.brs
function TestSuite__CacheFS() as Object
  ts = KopytkoTestSuite()
  ts.name = "CacheFS"

  ts.setBeforeEach(sub (ts as Object)
    m.__mocks = {}
    m.__mocks.EVPDigest = {
      process: {
        returnValue: "stringValue",
      },
    }

    ts.__dataKey = "example key"
  end sub)

  ts.setAfterEach(sub (ts as Object)
    CacheFS().delete(ts.__dataKey)
  end sub)

  ts.addTest("constructor creates EVPDigest and sets sha1 algorithm", function (ts as Object) as String
    ' When
    CacheFS()

    ' Then
    return ts.assertMethodWasCalled("EVPDigest.setup", { digestType: "sha1" })
  end function)

  ts.addParameterizedTests([
    { super: "data" },
    [1, 2, 3],
    "",
    777,
  ], "read returns data stored via write method", function (ts as Object, data as Object) as String
    ' Given
    cache = CacheFS()
    if (NOT cache.write(ts.__dataKey, data))
      return ts.fail("Couldn't write data to CacheFS")
    end if

    ' When
    returnedData = cache.read(ts.__dataKey)

    ' Then
    return ts.assertEqual(returnedData, data)
  end function)

  ts.addTest("read returns invalid in case of empty data under the given key", function (ts as Object) as String
    ' Given
    cache = CacheFS()

    ' When
    returnedData = cache.read("any key")

    ' Then
    return ts.assertInvalid(returnedData)
  end function)

  ts.addTest("read returns invalid in case of empty key passed", function (ts as Object) as String
    ' Given
    cache = CacheFS()

    ' When
    returnedData = cache.read("")

    ' Then
    return ts.assertInvalid(returnedData)
  end function)

  ts.addTest("write returns false in case of empty key passed", function (ts as Object) as String
    ' Given
    cache = CacheFS()

    ' When
    returnedData = cache.write("", { any: "data" })

    ' Then
    return ts.assertFalse(returnedData)
  end function)

  ts.addTest("write returns false in case of invalid data passed", function (ts as Object) as String
    ' Given
    cache = CacheFS()

    ' When
    returnedData = cache.write(ts.__dataKey, Invalid)

    ' Then
    return ts.assertFalse(returnedData)
  end function)

  ts.addTest("write returns false in case of non-parseable data passed", function (ts as Object) as String
    ' Given
    cache = CacheFS()

    ' When
    returnedData = cache.write(ts.__dataKey, CreateObject("roDateTime"))

    ' Then
    return ts.assertFalse(returnedData)
  end function)

  ts.addTest("delete deletes data stored under the given key", function (ts as Object) as String
    ' Given
    data = { super: "data" }

    cache = CacheFS()
    if (NOT cache.write(ts.__dataKey, data))
      return ts.fail("Couldn't write data to CacheFS")
    end if

    ' When
    if (NOT cache.delete(ts.__dataKey))
      return ts.fail("Couldn't delete data from CacheFS")
    end if
    returnedData = cache.read(ts.__dataKey)

    ' Then
    return ts.assertInvalid(returnedData)
  end function)

  ts.addTest("delete returns false in case of empty key passed", function (ts as Object) as String
    ' Given
    cache = CacheFS()

    ' When
    result = cache.delete("")

    ' Then
    return ts.assertFalse(result)
  end function)

  return ts
end function
