cmake_minimum_required(VERSION 3.10)
SET(PROJECT j0CC_FamiTracker)

project(${PROJECT})
set(CMAKE_CXX_STANDARD 17)


# debug build
add_definitions(-D_AFXDLL)
set(CMAKE_MFC_FLAG 2)

## release build
#set(CMAKE_MFC_FLAG 1)

include(exe.cmake)

TARGET_LINK_LIBRARIES(${PROJECT}
        Dbghelp winmm comctl32 dsound dxguid Version)
