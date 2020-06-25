# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
# This is a re-write of the partition module using QML view steps
# instead of widgets.

calamares_add_plugin( partitionq
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
	PartitionJob.cpp
	PartitionJob.h
        Config.cpp
        Config.h
        PartitionQmlViewStep.cpp
    RESOURCES
        partitionq.qrc
    LINK_PRIVATE_LIBRARIES
        calamaresui
    SHARED_LIB
)
