' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function TestSuite__uuid() as Object
  ts = KopytkoTestSuite()
  ts.name = "uuid"

  ts.addTest("should have proper format of returned hash", function (ts as Object) as String
    ' Given
    expectedResult = [8, 4, 4, 4, 12]

    ' When
    hash = uuid()
    result = hash.split("-")

    for i = 0 to 4
      result[i] = Len(result[i])
    end for

    ' Then
    return ts.assertEqual(result, expectedResult)
  end function)

  ts.addTest("should generate random hashes", function (ts as Object) as String
    ' Given
    hashes1 = []
    hashes2 = []

    ' When
    for i = 0 to 50
      hashes1.push(uuid())
      hashes2.push(uuid())
    end for

    ' Then
    return ts.assertNotEqual(hashes1, hashes2)
  end function)

  return ts
end function
