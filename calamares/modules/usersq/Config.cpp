/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "Config.h"
#include <QVariant>

Config::Config( QObject* parent )
    : QObject( parent )
{
}

void
Config::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_arch = configurationMap.value("arch").toString();
    m_device = configurationMap.value("device").toString();
    m_userInterface = configurationMap.value("userInterface").toString();
    m_version = configurationMap.value("version").toString();
}
