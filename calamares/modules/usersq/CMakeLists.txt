# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
# This is a re-write of the users module using QML view steps
# instead of widgets.

calamares_add_plugin( usersq
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        Config.cpp
        Config.h
        UsersJob.cpp
        UsersJob.h
        UsersQmlViewStep.cpp
    RESOURCES
        usersq.qrc
    LINK_PRIVATE_LIBRARIES
        calamaresui
    SHARED_LIB
)
