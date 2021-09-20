' Calls given function with given number of arguments in a specific context. Compare apply in JavaScript.
' @example
' function adder(arg1, arg2, arg3, arg4) as Integer
'   return m.base + arg1 + arg2 + arg3 + arg4
' end function
' funcionCall(adder, [1, 2, 3, 4], { base: 1 })
' @param {Function|Invalid} func
' @param {Dynamic[]} [args=[]]
' @param {Object} [context=Invalid]
' @returns {Dynamic}
function functionCall(func as Dynamic, args = [] as Object, context = Invalid as Object) as Dynamic
  if (func = Invalid)
    return Invalid
  end if

  if (context = Invalid) then context = GetGlobalAA()

  context["$$functionCall"] = func

  argumentsNumber = args.count()
  if (argumentsNumber = 0)
    result = context["$$functionCall"]()
  else if (argumentsNumber = 1)
    result = context["$$functionCall"](args[0])
  else if (argumentsNumber = 2)
    result = context["$$functionCall"](args[0], args[1])
  else if (argumentsNumber = 3)
    result = context["$$functionCall"](args[0], args[1], args[2])
  else if (argumentsNumber = 4)
    result = context["$$functionCall"](args[0], args[1], args[2], args[3])
  else
    ?"functionCall: too many arguments!"
    result = Invalid
  end if

  context.delete("$$functionCall")

  return result
end function
