cmake_minimum_required(VERSION 3.25)
project(rpg_maker)

include(CMakeDependentOption)

# Project options (dependent)
cmake_dependent_option(RPGMK_USE_X11 "Use X11 instead of Wayland" ON
                       "NOT RPGMK_USE_WAYLAND;UNIX;NOT APPLE" OFF)

cmake_dependent_option(RPGMK_USE_WAYLAND "Use Wayland instead of X11" OFF
                       "NOT RPGMK_USE_X11;UNIX;NOT APPLE" OFF)

cmake_dependent_option(
  RPGMK_USE_D3D "Use the Direct3D graphics library" ON
  "NOT RPGMK_USE_OPENGL;NOT RPGMK_USE_OPENGL_ES;NOT RPGMK_USE_VULKAN;WIN32" OFF)

cmake_dependent_option(
  RPGMK_USE_METAL "Use the Metal graphics library" ON
  "NOT RPGMK_USE_OPENGL;NOT RPGMK_USE_OPENGL_ES;NOT RPGMK_USE_VULKAN;APPLE" OFF)

cmake_dependent_option(
  RPGMK_USE_OPENGL
  "Use the OpenGL graphics library"
  ON
  "NOT RPGMK_USE_D3D;NOT RPGMK_USE_METAL;NOT RPGMK_USE_OPENGL_ES;NOT RPGMK_USE_VULKAN"
  OFF)

cmake_dependent_option(
  RPGMK_USE_OPENGL_ES "Use the OpenGL-ES graphics library" OFF
  "NOT RPGMK_USE_D3D;NOT RPGMK_USE_METAL;NOT RPGMK_USE_OPENGL;NOT USE_VULKAN"
  OFF)

cmake_dependent_option(
  RPGMK_USE_VULKAN
  "Use the Vulkan graphics library"
  OFF
  "NOT RPGMK_USE_D3D;NOT RPGMK_USE_METAL;NOT RPGMK_USE_OPENGL;NOT RPGMK_USE_OPENGL_ES"
  OFF)

# The CMake modules paths to be appended to the existing ones
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

# Create system dependent definitions
if(WIN32)
  message(FATAL_ERROR "Windows is not supported yet")
  add_compile_definitions(RPGMK_WIN32)
elseif(APPLE)
  message(FATAL_ERROR "Apple devices not supported yet")
  add_compile_definitions(RPGMK_APPLE)
elseif(UNIX AND NOT APPLE)
  message(STATUS "Configuring for UNIX (not Apple) devices")
  add_compile_definitions(RPGMK_UNIX_NOT_APPLE)
else()
  message(FATAL_ERROR "Platform not supported")
endif()

# Create windowing API dependent definitions
if(RPGMK_USE_X11)
  message(STATUS "Configuring for X11 windowing API")
  add_compile_definitions(RPGMK_X11)
elseif(RPGMK_USE_WAYLAND)
  message(FATAL_ERROR "Wayland windowing API not supported yet")
  message(STATUS "Configuring for Wayland windowing API")
  add_compile_definitions(RPGMK_WAYLAND)
elseif(WIN32)
  message(FATAL_ERROR "Win API windowing API not supported yet")
  message(STATUS "Configuring for Win API windowing API")
  add_compile_definitions(RPGMK_WIN_API)
elseif(APPLE)
  message(FATAL_ERROR "Cocoa windowing API not supported yet")
  message(STATUS "Configuring for Cocoa windowing API")
  add_compile_definitions(RPGMK_COCOA_API)
else()
  message(FATAL_ERROR "Windowing API not supported")
endif()

# Create graphics API dependent definitions
if(RPGMK_USE_D3D)
  message(FATAL_ERROR "Direct3D graphics API not supported yet")
  message(STATUS "Configuring for Direct3D graphics API")
  add_compile_definitions(RPGMK_D3D)
elseif(RPGMK_USE_METAL)
  message(FATAL_ERROR "Metal graphics API not supported yet")
  message(STATUS "Configuring for Metal graphics API")
  add_compile_definitions(RPGMK_METAL)
elseif(RPGMK_USE_OPENGL)
  message(STATUS "Configuring for OpenGL graphics API")
  add_compile_definitions(RPGMK_OPENGL)
elseif(RPGMK_USE_OPENGL_ES)
  message(FATAL_ERROR "OpenGL-ES graphics API not supported yet")
  message(STATUS "Configuring for OpenGL-ES graphics API")
  add_compile_definitions(RPGMK_OPENGL_ES)
elseif(RPGMK_USE_VULKAN)
  message(FATAL_ERROR "Vulkan graphics API not supported yet")
  message(STATUS "Configuring for Vulkan graphics API")
  add_compile_definitions(RPGMK_VULKAN)
else()
  message(FATAL_ERROR "Graphics API not supported")
endif()

# Create a common variable to find the root directory safely
set(RPGMK_SOURCE_DIR ${PROJECT_SOURCE_DIR})
