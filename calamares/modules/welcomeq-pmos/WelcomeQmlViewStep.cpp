/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2014-2015, Teo Mrnjavac <teo@kde.org>
 *   Copyright 2018,2020 Adriaan de Groot <groot@kde.org>
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

#include "WelcomeQmlViewStep.h"
#include <QProcess>

CALAMARES_PLUGIN_FACTORY_DEFINITION( WelcomeQmlViewStepFactory, registerPlugin< WelcomeQmlViewStep >(); )

void
WelcomeQmlViewStep::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_config->setConfigurationMap( configurationMap );
    Calamares::QmlViewStep::setConfigurationMap( configurationMap );
}

WelcomeQmlViewStep::WelcomeQmlViewStep( QObject* parent )
    : Calamares::QmlViewStep( parent )
    , m_config( new Config( this ) )
{
}

void
WelcomeQmlViewStep::onLeave()
{
}

QString
WelcomeQmlViewStep::prettyName() const
{
    return tr( "Welcome" );
}

bool
WelcomeQmlViewStep::isNextEnabled() const
{
    return false;
}

bool
WelcomeQmlViewStep::isBackEnabled() const
{
    return false;
}


bool
WelcomeQmlViewStep::isAtBeginning() const
{
    return true;
}


bool
WelcomeQmlViewStep::isAtEnd() const
{
    return true;
}


Calamares::JobList
WelcomeQmlViewStep::jobs() const
{
    return Calamares::JobList();
}

QObject*
WelcomeQmlViewStep::getConfig()
{
    return m_config;
}
