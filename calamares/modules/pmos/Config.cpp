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

void
Config::setUserPassword( const QString &userPassword )
{
    m_userPassword = userPassword;
    emit userPasswordChanged( m_userPassword );
}

void
Config::setSshUsername( const QString &sshUsername )
{
    m_sshUsername = sshUsername;
    emit sshUsernameChanged( m_sshUsername );
}

void
Config::setSshPassword( const QString &sshPassword )
{
    m_sshPassword = sshPassword;
    emit sshPasswordChanged( m_sshPassword );
}

void
Config::setIsSshEnabled( const bool isSshEnabled )
{
    m_isSshEnabled = isSshEnabled;
}

void
Config::setFdePassword( const QString &fdePassword )
{
    m_fdePassword = fdePassword;
    emit fdePasswordChanged( m_fdePassword );
}

void
Config::setIsFdeEnabled( const bool isFdeEnabled )
{
    m_isFdeEnabled = isFdeEnabled;
}
