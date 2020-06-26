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

#include "PartitionQmlViewStep.h"
#include "PartitionJob.h"

#include "GlobalStorage.h"
#include "JobQueue.h"

#include "locale/LabelModel.h"
#include "utils/Dirs.h"
#include "utils/Logger.h"
#include "utils/Variant.h"

#include "Branding.h"
#include "modulesystem/ModuleManager.h"
#include "utils/Yaml.h"

#include <QProcess>

CALAMARES_PLUGIN_FACTORY_DEFINITION( PartitionQmlViewStepFactory, registerPlugin< PartitionQmlViewStep >(); )

void
PartitionQmlViewStep::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_config->setConfigurationMap( configurationMap );
    Calamares::QmlViewStep::setConfigurationMap( configurationMap );
}

PartitionQmlViewStep::PartitionQmlViewStep( QObject* parent )
    : Calamares::QmlViewStep( parent )
    , m_config( new Config( this ) )
{
}

void
PartitionQmlViewStep::onLeave()
{
    /* Don't add the job if user hit back button */
    if (m_config->isReady()) {
        Calamares::Job *j = new PartitionJob( m_config->isFdeEnabled(),
                                              m_config->password() );
        m_jobs.append( Calamares::job_ptr( j ) );
    }
}

QString
PartitionQmlViewStep::prettyName() const
{
    return tr( "Partition" );
}

bool
PartitionQmlViewStep::isNextEnabled() const
{
    return false;
}

bool
PartitionQmlViewStep::isBackEnabled() const
{
    return false;
}


bool
PartitionQmlViewStep::isAtBeginning() const
{
    return true;
}


bool
PartitionQmlViewStep::isAtEnd() const
{
    return true;
}


Calamares::JobList
PartitionQmlViewStep::jobs() const
{
    return m_jobs;
}

QObject*
PartitionQmlViewStep::getConfig()
{
    return m_config;
}
