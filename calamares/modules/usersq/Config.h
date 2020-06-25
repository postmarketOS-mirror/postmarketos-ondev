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

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString username() const { return m_username; }
    QString password() const { return m_password; }
    QString passwordRepeat() const { return m_passwordRepeat; }

    void setUsername( const QString &username );
    void setPassword( const QString &password );
    void setPasswordRepeat( const QString &passwordRepeat );

private:
    QString m_username;
    QString m_password;
    QString m_passwordRepeat;

signals:
    void usernameChanged ( QString username );
    void passwordChanged ( QString password );
    void passwordRepeatChanged ( QString passwordRepeat );
};
