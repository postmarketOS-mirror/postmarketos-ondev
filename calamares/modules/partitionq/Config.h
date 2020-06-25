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
    Q_PROPERTY( bool isFdeEnabled READ isFdeEnabled WRITE setIsFdeEnabled )
    Q_PROPERTY( bool isReady READ isReady WRITE setIsReady )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString password() const { return m_password; }
    bool isFdeEnabled() { return m_isFdeEnabled; }
    bool isReady() { return m_isReady; }

    void setPassword( const QString &password );
    void setIsFdeEnabled( bool isFdeEnabled );
    void setIsReady( bool isReady );

private:
    QString m_password;
    bool m_isFdeEnabled;
    bool m_isReady = false;

signals:
    void passwordChanged ( QString password );
};
