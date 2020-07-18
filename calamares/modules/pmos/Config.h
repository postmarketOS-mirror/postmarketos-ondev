/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    /* welcome */
    Q_PROPERTY( QString arch READ arch CONSTANT FINAL )
    Q_PROPERTY( QString device READ device CONSTANT FINAL )
    Q_PROPERTY( QString userInterface READ userInterface CONSTANT FINAL )
    Q_PROPERTY( QString version READ version CONSTANT FINAL )

    /* default user */
    Q_PROPERTY( QString userPassword READ userPassword WRITE setUserPassword
                NOTIFY userPasswordChanged)

    /* ssh server + credentials */
    Q_PROPERTY( QString sshUsername READ sshUsername WRITE setSshUsername
                NOTIFY sshUsernameChanged)
    Q_PROPERTY( QString sshPassword READ sshPassword WRITE setSshPassword
                NOTIFY sshPasswordChanged)
    Q_PROPERTY( bool isSshEnabled READ isSshEnabled WRITE setIsSshEnabled )

    /* full disk encryption */
    Q_PROPERTY( QString fdePassword READ fdePassword WRITE setFdePassword
                NOTIFY fdePasswordChanged)
    Q_PROPERTY( bool isFdeEnabled READ isFdeEnabled WRITE setIsFdeEnabled )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    /* welcome */
    QString arch() const { return m_arch; }
    QString device() const { return m_device; }
    QString userInterface() const { return m_userInterface; }
    QString version() const { return m_version; }

    /* default user */
    QString userPassword() const { return m_userPassword; }
    void setUserPassword( const QString &userPassword );

    /* ssh server + credetials */
    QString sshUsername() const { return m_sshUsername; }
    QString sshPassword() const { return m_sshPassword; }
    bool isSshEnabled() { return m_isSshEnabled; }
    void setSshUsername( const QString &sshUsername );
    void setSshPassword( const QString &sshPassword );
    void setIsSshEnabled( bool isSshEnabled );

    /* full disk encryption */
    QString fdePassword() const { return m_fdePassword; }
    bool isFdeEnabled() { return m_isFdeEnabled; }
    void setFdePassword( const QString &fdePassword );
    void setIsFdeEnabled( bool isFdeEnabled );

private:
    /* welcome */
    QString m_arch;
    QString m_device;
    QString m_userInterface;
    QString m_version;

    /* default user */
    QString m_userPassword;

    /* ssh server + credetials */
    QString m_sshUsername;
    QString m_sshPassword;
    bool m_isSshEnabled;

    /* full disk encryption */
    QString m_fdePassword = "";
    bool m_isFdeEnabled = false;

signals:
    /* default user */
    void userPasswordChanged ( QString userPassword );

    /* ssh server + credetials */
    void sshUsernameChanged ( QString sshUsername );
    void sshPasswordChanged ( QString sshPassword );
    /* isSshEnabled doesn't need a signal, we don't read it from QML */

    /* full disk encryption */
    void fdePasswordChanged ( QString fdePassword );
};
