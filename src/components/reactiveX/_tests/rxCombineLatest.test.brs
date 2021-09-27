' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @import /components/reactiveX/RxSubject.brs
function TestSuite__rxCombineLatest() as Object
  ts = KopytkoTestSuite()
  ts.name = "rxCombineLatest"

  ts.setBeforeEach(sub (ts as Object)
    m.__streamValues = []
  end sub)

  ts.addParameterizedTests([0, 1], "it does not emit any value if not of all streams emitted a value - subject with index {0}", function (ts as Object, subjectToEmit as Integer) as String
    ' Given
    subjects = [RxSubject(), RxSubject()]
    combined = rxCombineLatest(subjects)
    combined.subscribe(sub (values as Object)
      m.__streamValues.push(values)
    end sub, Invalid, Invalid, m)

    ' When
    subjects[subjectToEmit].next("any")

    ' Then
    return ts.assertTrue(m.__streamValues.isEmpty())
  end function)

  ts.addTest("it emits a value if all streams emitted a value", function (ts as Object) as Object
    ' Given
    subjects = [RxSubject(), RxSubject()]
    combined = rxCombineLatest(subjects)
    combined.subscribe(sub (values as Object)
      m.__streamValues.push(values)
    end sub, Invalid, Invalid, m)

    ' When
    subjects[0].next("first")
    subjects[1].next("second")

    ' Then
    return ts.assertEqual(m.__streamValues, [["first", "second"]])
  end function)

  ts.addTest("it emits a new value if one of streams emitted another value", function (ts as Object) as Object
    ' Given
    subjects = [RxSubject(), RxSubject()]
    combined = rxCombineLatest(subjects)
    combined.subscribe(sub (values as Object)
      m.__streamValues.push(values)
    end sub, Invalid, Invalid, m)

    ' When
    subjects[0].next("first")
    subjects[1].next("second")
    subjects[1].next("another second")
    subjects[0].next("first another")

    ' Then
    return ts.assertEqual(m.__streamValues, [["first", "second"], ["first", "another second"], ["first another", "another second"]])
  end function)

  return ts
end function
