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
    /* Not using any config values yet. The Config.cpp/Config.h is convention
     * for transfering data between QML and C++ code in Calamares, and we use
     * it to transfer what the user typed in (username, pass etc.) to the
     * global config, so it can be used later in the installation. */
}

void
Config::setPassword( const QString &password )
{
    m_password = password;
    emit passwordChanged( m_password );
}

void
Config::setIsFdeEnabled( const bool isFdeEnabled )
{
    m_isFdeEnabled = isFdeEnabled;
}