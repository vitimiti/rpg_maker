# ===============================================================================
# The MIT License (MIT)
#
# Copyright (c) 2023 Victor Matia <vmatir@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ===============================================================================

function(target_set_default_compile_options _TARGET _VISIBILITY
         _WARNINGS_AS_ERRORS)
  target_compile_options(
    ${_TARGET}
    ${_VISIBILITY}
    # MSVC Flags
    #
    # Level 4 warnings
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/W4>
    # 'identifier' : conversion from 'type1' to 'type2', possible loss of data
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14242>
    # 'operator' : conversion from 'type1' to 'type2', possible loss of data
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14254>
    # 'function' : member function does not override any base class virtual
    # member function
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14263>
    # 'class' : class has virtual functions, but destructor is not virtual
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14265>
    # 'operator' : unsigned/negative constant mismatch
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14287>
    # nonstandard extension used : 'var' : loop control variable declared in the
    # for-loop is used outside the for-loop scope
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/we4289>
    # 'operator' : expression is always false
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14296>
    # 'variable' : pointer truncation from 'type' to 'type'
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14311>
    # expression before comma evaluates to a function which is missing an
    # argument list
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14545>
    # function call before comma missing argument list
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14546>
    # 'operator' : operator before comma has no effect; expected operator with
    # side-effect
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14547>
    # 'operator' : operator before comma has no effect; did you intend
    # 'operator'?
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14549>
    # expression has no effect; expected expression with side-effect
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14555>
    # #pragma warning : there is no warning number 'number'
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14619>
    # 'instance' : construction of local static object is not thread-safe
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14640>
    # wide string literal cast to 'LPSTR'
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14905>
    # string literal cast to 'LPWSTR'
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14906>
    # illegal copy-initialization; more than one user-defined conversion has
    # been implicitly applied
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/w14928>
    # Specify standards conformance mode to the compiler. Use this option to
    # help you identify and fix conformance issues in your code, to make it both
    # more correct and more portable
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/permissive->
    # Make messages look prettier
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/diagnostics:column>
    # For Debug and RelWithDebInfo
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug,RelWithDebInfo>>:/Zi>
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug,RelWithDebInfo>>:/MDd>
    # For Release
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Release>>:/O2>
    # FOr MinSizeRel
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:MinSizeRel>>:/Os>
    # For Release and MinSizeRel
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Release,MinSizeRel>>:/MD>
    # GNU / Clang Flags
    #
    # "All" warnings
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wall>
    # Extra warnings
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wextra>
    # Warn about redundant semicolons after in-class function definitions
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wextra-semi>
    # Issue all the warnings demanded by strict ISO C and ISO C++; reject all
    # programs that use forbidden extensions, and some other programs that do
    # not follow ISO C and ISO C++
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wpedantic>
    # Warn whenever a local variable or type declaration shadows another
    # variable, parameter, type, class member
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wshadow>
    # Warn when a class has virtual functions and an accessible non-virtual
    # destructor itself or in an accessible polymorphic base class
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wnon-virtual-dtor>
    # Warn if an old-style (C-style) cast to a non-void type is used within a
    # C++ program
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wold-style-cast>
    # Warn whenever a pointer is cast such that the required alignment of the
    # target is increased
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wcast-align>
    # Warn about unused variables
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wunused>
    # Warn when a function declaration hides virtual functions from a base class
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Woverloaded-virtual>
    # Warn for implicit conversions that may alter a value
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wconversion>
    # Warn for implicit conversions that may change the sign of an integer
    # value, like assigning a signed integer expression to an unsigned integer
    # variable
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wsign-conversion>
    # Warn if the compiler detects paths that trigger erroneous or undefined
    # behavior due to dereferencing a null pointer
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wnull-dereference>
    # Give a warning when a value of type float is implicitly promoted to double
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wdouble-promotion>
    # Check calls to printf and scanf, etc., to make sure that the arguments
    # supplied have types appropriate to the format string specified, and that
    # the conversions specified in the format string make sense
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wformat=2>
    # Warn when a switch case falls through
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Wimplicit-fallthrough>
    # For Debug
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug>>:-Og>
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug>>:-g3>
    # For Release
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Release>>:-O3>
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Release>>:-g0>
    # For RelWithDebInfo
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:RelWithDebInfo>>:-O2>
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:RelWithDebInfo>>:-g2>
    # For MinSizeRel
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:MinSizeRel>>:-Oz>
    $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>,$<CONFIG:MinSizeRel>>:-g0>
    # GNU Flags
    #
    # Warn when the indentation of the code does not reflect the block structure
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wmisleading-indentation>
    # Warn about duplicated conditions in an if-else-if chain
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wduplicated-cond>
    # Warn when an if-else has identical branches
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wduplicated-branches>
    # Warn about suspicious uses of logical operators in expressions
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wlogical-op>
    # Warn when an expression is cast to its own type
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wuseless-cast>
    # Make messages look prettier
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-fdiagnostics-color=always>
    # Clang Flags
    #
    # Make messages look prettier
    $<$<AND:$<CXX_COMPILER_ID:Clang>,$<COMPILE_LANGUAGE:CXX>>:-fcolor-diagnostics>
  )

  if(${_WARNINGS_AS_ERRORS})
    target_compile_options(
      ${_TARGET}
      ${_VISIBILITY}
      # MSVC Flags
      #
      $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<COMPILE_LANGUAGE:CXX>>:/WX>
      # GNU / Clang Flags
      #
      $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<COMPILE_LANGUAGE:CXX>>:-Werror>
    )
  endif()
endfunction()
