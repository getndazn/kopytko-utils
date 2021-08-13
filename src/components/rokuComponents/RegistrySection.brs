' Wrapper function for creating native roRegistrySection with given section name.
' @class
' @param {String} name - Section name.
function RegistrySection(name as String) as Object
  return CreateObject("roRegistrySection", name)
end function
