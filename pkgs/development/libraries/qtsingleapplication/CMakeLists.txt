# This file is taken from openconnect-gui v1.6.2, and has been heavily modified.
# https://gitlab.com/openconnect/openconnect-gui/-/blob/v1.6.2/CMake/Includes/CMakeLists_qt-solutions.cmake.in?ref_type=tags

#
# Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
# Contact: http://www.qt-project.org/legal
#
# This file is part of the Qt Solutions component.
#
# You may use this file under the terms of the BSD license as follows:
#
# "Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
#     of its contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
#

cmake_minimum_required(VERSION 3.23 FATAL_ERROR)

project(qtsingleapplication
    VERSION 2.6
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt6 6.0 REQUIRED COMPONENTS Core Gui Widgets Network)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)
qt_policy(SET QTP0003 NEW) # respect BUILD_SHARED_LIBS

qt_standard_project_setup()
qt_add_library(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
    INTERFACE
        FILE_SET HEADERS
        BASE_DIRS src
        FILES
            src/QtSingleApplication
            src/QtLockedFile
            src/qtsingleapplication.h
            src/qtlockedfile.h
)

target_sources(${PROJECT_NAME}
    PRIVATE
        src/qtlocalpeer.cpp
        src/qtsingleapplication.cpp
        src/qtsinglecoreapplication.cpp
)

target_compile_options(${PROJECT_NAME}
    PRIVATE -Wno-deprecated-declarations
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
        Qt6::Network
)

install(
    TARGETS ${PROJECT_NAME}
        EXPORT ${PROJECT_NAME}
        LIBRARY
        RUNTIME
        FILE_SET HEADERS
)

install(
    EXPORT ${PROJECT_NAME}
        NAMESPACE qt-solutions::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)