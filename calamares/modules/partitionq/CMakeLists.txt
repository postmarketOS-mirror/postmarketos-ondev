# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
# This is a re-write of the partition module using QML view steps
# instead of widgets.

include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/../../libcalamaresui
		     ${CMAKE_CURRENT_SOURCE_DIR}/../../libcalamares )

calamares_add_plugin( partitionq
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        PartitionQmlViewStep.cpp
    RESOURCES
        partitionq.qrc
    LINK_PRIVATE_LIBRARIES
        calamaresui
    SHARED_LIB
)
