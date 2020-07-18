# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

calamares_add_plugin( pmos
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        MobileQmlViewStep.cpp
        MobileQmlViewStep.h
        PartitionJob.cpp
        PartitionJob.h
        UsersJob.cpp
        UsersJob.h
        Config.cpp
        Config.h
    RESOURCES
        pmos.qrc
    LINK_PRIVATE_LIBRARIES
        calamaresui
    SHARED_LIB
)
