/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString username READ username WRITE setUsername NOTIFY usernameChanged)

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString username() const { return m_username; }

    void setUsername( const QString &username );

private:
    QString m_username;

signals:
    void usernameChanged ( QString username );
};
