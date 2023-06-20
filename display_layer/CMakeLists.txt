project(display_layer)

# Include the required packages for the different systems
if(RPGMK_USE_X11)
  find_package(X11 REQUIRED)
endif()

if(RPGMK_USE_OPENGL)
  find_package(OpenGL REQUIRED)
endif()

list(APPEND PUBLIC_HEADERS)

list(APPEND SOURCES)

# The system specific sources

# Shared or static libraries
if(BUILD_SHARED_LIBS)
  add_library(${PROJECT_NAME} SHARED)
else()
  add_library(${PROJECT_NAME} STATIC)
endif()

target_sources(
  ${PROJECT_NAME}
  PUBLIC ${PUBLIC_HEADERS}
  PRIVATE ${SOURCES})

list(APPEND INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/include)

include(DefaultCompilerOptions)
target_set_default_compile_options(${PROJECT_NAME} PUBLIC ON)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)

# The windowing API specific include directories and link libraries
if(RPGMK_USE_X11)
  list(APPEND INCLUDE_DIRS ${X11_INCLUDE_DIRS})
  target_link_libraries(${PROJECT_NAME} PUBLIC ${X11_LIBRARIES})
  target_include_directories(${PROJECT_NAME} PUBLIC ${INCLUDE_DIRS})
endif()

# The graphics API specific include directories and link libraries
if(RPGMK_USE_OPENGL)
  list(APPEND INCLUDE_DIRS ${OPENGL_INCLUDE_DIR})
  target_link_libraries(
    ${PROJECT_NAME} PUBLIC ${OPENGL_gl_LIBRARY} ${OPENGL_glx_LIBRARY}
                           ${OPENGL_glu_LIBRARY}})
endif()
