/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString arch READ arch CONSTANT FINAL )
    Q_PROPERTY( QString device READ device CONSTANT FINAL )
    Q_PROPERTY( QString userInterface READ userInterface CONSTANT FINAL )
    Q_PROPERTY( QString version READ version CONSTANT FINAL )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    QString arch() const { return m_arch; }
    QString device() const { return m_device; }
    QString userInterface() const { return m_userInterface; }
    QString version() const { return m_version; }

private:
    QString m_arch;
    QString m_device;
    QString m_userInterface;
    QString m_version;
};
