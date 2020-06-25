/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString username READ username WRITE setUsername
                NOTIFY usernameChanged)
    Q_PROPERTY( QString password READ password WRITE setPassword
                NOTIFY passwordChanged)
    Q_PROPERTY( QString passwordRepeat READ passwordRepeat
                WRITE setPasswordRepeat NOTIFY passwordRepeatChanged)

    Q_PROPERTY( QString sshUsername READ sshUsername WRITE setSshUsername
                NOTIFY sshUsernameChanged)
    Q_PROPERTY( QString sshPassword READ sshPassword WRITE setSshPassword
                NOTIFY sshPasswordChanged)
    Q_PROPERTY( QString sshPasswordRepeat READ sshPasswordRepeat
                WRITE setSshPasswordRepeat NOTIFY sshPasswordRepeatChanged)

    Q_PROPERTY( bool isSshEnabled READ isSshEnabled WRITE setIsSshEnabled )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString username() const { return m_username; }
    QString password() const { return m_password; }
    QString passwordRepeat() const { return m_passwordRepeat; }

    QString sshUsername() const { return m_sshUsername; }
    QString sshPassword() const { return m_sshPassword; }
    QString sshPasswordRepeat() const { return m_sshPasswordRepeat; }

    bool isSshEnabled() { return m_isSshEnabled; }

    void setUsername( const QString &username );
    void setPassword( const QString &password );
    void setPasswordRepeat( const QString &passwordRepeat );

    void setSshUsername( const QString &sshUsername );
    void setSshPassword( const QString &sshPassword );
    void setSshPasswordRepeat( const QString &sshPasswordRepeat );

    void setIsSshEnabled( bool isSshEnabled );

private:
    QString m_username;
    QString m_password;
    QString m_passwordRepeat;

    QString m_sshUsername;
    QString m_sshPassword;
    QString m_sshPasswordRepeat;

    bool m_isSshEnabled;

signals:
    void usernameChanged ( QString username );
    void passwordChanged ( QString password );
    void passwordRepeatChanged ( QString passwordRepeat );

    void sshUsernameChanged ( QString sshUsername );
    void sshPasswordChanged ( QString sshPassword );
    void sshPasswordRepeatChanged ( QString sshPasswordRepeat );

    /* isSshEnabled doesn't need a signal, we don't read it from QML */
};
