/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2019-2020 Adriaan de Groot <groot@kde.org>
 *   Copyright 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 *
 *   Calamares is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Calamares is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once
#include "Config.h"

#include "utils/PluginFactory.h"
#include "viewpages/QmlViewStep.h"

#include <DllMacro.h>

#include <QObject>
#include <QVariantMap>

class PLUGINDLLEXPORT UsersQmlViewStep : public Calamares::QmlViewStep
{
    Q_OBJECT

public:
    explicit UsersQmlViewStep( QObject* parent = nullptr );

    QString prettyName() const override;

    bool isNextEnabled() const override;
    bool isBackEnabled() const override;
    bool isAtBeginning() const override;
    bool isAtEnd() const override;

    Calamares::JobList jobs() const override;

    void setConfigurationMap( const QVariantMap& configurationMap ) override;
    void onLeave();
    QObject* getConfig() override;

private:
    Config* m_config;
};

CALAMARES_PLUGIN_FACTORY_DECLARATION( UsersQmlViewStepFactory )
