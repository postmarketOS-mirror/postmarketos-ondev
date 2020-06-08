# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

project(calamares-branding LANGUAGES CXX)
cmake_minimum_required(VERSION 3.2)


find_package(Calamares REQUIRED)
find_package(KF5CoreAddons REQUIRED)
find_package(Qt5 ${QT_VERSION} REQUIRED Quick QuickWidgets Xml Svg)

set( CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMakeModules" )
find_package(YAMLCPP REQUIRED)

include("${CALAMARES_USE_FILE}")

# Branding
calamares_add_branding_subdirectory( branding/postmarketos NAME postmarketos )

# Modules
include_directories(${CALAMARES_INCLUDE_DIRS})
calamares_add_module_subdirectory( modules/partitionq )
