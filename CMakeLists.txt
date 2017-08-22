cmake_minimum_required (VERSION 3.5)
include(GNUInstallDirs)
project (VulkanTriangle)
IF (DEFINED NDEBUG)
ADD_DEFINITIONS(-DNEBUG=${NDEBUG})
ENDIF()
set (VERSION_MAJOR 1)
set (VERSION_MINOR 0)
configure_file (
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
    )
IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
# Mac OS X specific code
SET(macOS ON)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
set (VULKAN_SDK_PATH /home/gowtham/Downloads/VulkanSDK/1.0.51.0/x86_64)
set (GCC_COVERAGE_COMPILE_FLAGS "-std=c++14")
EXEC_PROGRAM(pkg-config
		ARGS --static --libs glfw3
		OUTPUT_VARIABLE L_GLFW)
set (GCC_COVERAGE_LINK_FLAGS "${L_GLFW}")
IF (NOT DEFINED NDEBUG)
set (GCC_COVERAGE_COMPILE_FLAGS "${GCC_COVERAGE_COMPILE_FLAGS} -g")
set (GCC_COVERAGE_LINK_FLAGS "${GCC_COVERAGE_LINK_FLAGS} -g")
ENDIF()
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}")
set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")
file(GLOB HEADERS *.h)
file(GLOB SOURCES *.cpp)
include_directories(${PROJECT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
include_directories ($(VULKAN_SDK_PATH)/include)
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} shader_base.frag shader_base.vert compile.sh)
link_directories($(VULKAN_SDK_PATH)/lib)
target_link_libraries(${PROJECT_NAME} vulkan)
set_target_properties(${PROJECT_NAME}
    PROPERTIES
    VERSION ${VERSION_MAJOR}.${VERSION_MINOR}
    SOVERSION ${VERSION_MAJOR}

    )
install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
add_custom_target(
    run LD_LIBRARY_PATH=${VULKAN_SDK_PATH}/lib VK_LAYER_PATH=${VULKAN_SDK_PATH}/etc/explicit_layer.d ./${PROJECT_NAME}
)
