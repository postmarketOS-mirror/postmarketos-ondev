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

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString password() const { return m_password; }
    bool isFdeEnabled() { return m_isFdeEnabled; }

    void setPassword( const QString &password );
    void setIsFdeEnabled( bool isFdeEnabled );

private:
    QString m_password = "";
    bool m_isFdeEnabled = false;

signals:
    void passwordChanged ( QString password );
};
