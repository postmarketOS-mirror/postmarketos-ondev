/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString password READ password WRITE setPassword
                NOTIFY passwordChanged)

    Q_PROPERTY( QString sshUsername READ sshUsername WRITE setSshUsername
                NOTIFY sshUsernameChanged)
    Q_PROPERTY( QString sshPassword READ sshPassword WRITE setSshPassword
                NOTIFY sshPasswordChanged)

    Q_PROPERTY( bool isSshEnabled READ isSshEnabled WRITE setIsSshEnabled )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString password() const { return m_password; }

    QString sshUsername() const { return m_sshUsername; }
    QString sshPassword() const { return m_sshPassword; }

    bool isSshEnabled() { return m_isSshEnabled; }

    void setPassword( const QString &password );

    void setSshUsername( const QString &sshUsername );
    void setSshPassword( const QString &sshPassword );

    void setIsSshEnabled( bool isSshEnabled );

private:
    QString m_password;

    QString m_sshUsername;
    QString m_sshPassword;

    bool m_isSshEnabled;

signals:
    void passwordChanged ( QString password );

    void sshUsernameChanged ( QString sshUsername );
    void sshPasswordChanged ( QString sshPassword );

    /* isSshEnabled doesn't need a signal, we don't read it from QML */
};
