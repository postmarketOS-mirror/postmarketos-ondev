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

#include "MobileQmlViewStep.h"
#include "PartitionJob.h"
#include "UsersJob.h"

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

CALAMARES_PLUGIN_FACTORY_DEFINITION( MobileQmlViewStepFactory, registerPlugin< MobileQmlViewStep >(); )

void
MobileQmlViewStep::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_config->setConfigurationMap( configurationMap );
    Calamares::QmlViewStep::setConfigurationMap( configurationMap );
}

MobileQmlViewStep::MobileQmlViewStep( QObject* parent )
    : Calamares::QmlViewStep( parent )
    , m_config( new Config( this ) )
{
}

void
MobileQmlViewStep::onLeave()
{
    Calamares::Job *partition, *users;

    /* HACK: run partition job now */
    partition = new PartitionJob( m_config->isFdeEnabled(),
                                  m_config->fdePassword() );
    Calamares::JobResult res = partition->exec();
    if ( !res )
        cError() << "PARTITION JOB FAILED: " << res.message();

    /* Put users job in queue (should run after unpackfs) */
    m_jobs.clear();
    users = new UsersJob( m_config->userPassword(),
                          m_config->isSshEnabled(),
                          m_config->sshUsername(),
                          m_config->sshPassword() );
    m_jobs.append( Calamares::job_ptr( users ) );
}

bool
MobileQmlViewStep::isNextEnabled() const
{
    return false;
}

bool
MobileQmlViewStep::isBackEnabled() const
{
    return false;
}


bool
MobileQmlViewStep::isAtBeginning() const
{
    return true;
}


bool
MobileQmlViewStep::isAtEnd() const
{
    return true;
}


Calamares::JobList
MobileQmlViewStep::jobs() const
{
    return m_jobs;
}

QObject*
MobileQmlViewStep::getConfig()
{
    return m_config;
}
