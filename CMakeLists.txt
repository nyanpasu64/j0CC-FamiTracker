# TODO: Look at https://github.com/Kitware/CMake/tree/master/Tests/MFC to fix release builds

cmake_minimum_required(VERSION 3.10)
project(j0CC_FamiTracker)
set(CMAKE_CXX_STANDARD 17)


# debug build
add_definitions(-D_AFXDLL)
set(CMAKE_MFC_FLAG 2)

## release build
#set(CMAKE_MFC_FLAG 1)



# compiling

include(exe.cmake)


# linking

TARGET_LINK_LIBRARIES(${PROJECT_NAME}
        Dbghelp winmm comctl32 dsound dxguid Version)


# 0CC-FamiTracker.rc includes res/0CC-FamiTracker.manifest.
# To prevent manifest linking errors:
# - res/0CC-FamiTracker.manifest MUST not be in add_executable().
# - /MANIFEST:NO must be passed into the linker.

set_target_properties(${PROJECT_NAME} PROPERTIES
        LINK_FLAGS
            /MANIFEST:NO)
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /MANIFEST:NO")
