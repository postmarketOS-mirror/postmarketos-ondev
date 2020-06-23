# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
# postmarketOS specific welcome screen, that has not much in common with the
# upstream welcomeq module from Calamares. We don't need the free space,
# network etc. checks, we don't have translations yet. But we do want to
# display the device name, arch and the UI that is going to be installed.

calamares_add_plugin( welcomeq-pmos
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        Config.h
        Config.cpp
        WelcomeQmlViewStep.cpp
    RESOURCES
        welcomeq-pmos.qrc
    LINK_PRIVATE_LIBRARIES
        calamaresui
    SHARED_LIB
)
