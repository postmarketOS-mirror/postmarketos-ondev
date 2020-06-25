/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2014, Teo Mrnjavac <teo@kde.org>
 *   Copyright 2015, Rohan Garg <rohan@garg.io>
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

#include "PartitionJob.h"

#include "GlobalStorage.h"
#include "JobQueue.h"
#include "Settings.h"
#include "utils/CalamaresUtilsSystem.h"
#include "utils/Logger.h"

#include <QDir>
#include <QFileInfo>


PartitionJob::PartitionJob( bool isFdeEnabled, const QString& password )
    : Calamares::Job()
    , m_isFdeEnabled ( isFdeEnabled )
    , m_password ( password )
{
}


QString
PartitionJob::prettyName() const
{
    return "Creating and formatting installation partition";
}


Calamares::JobResult
PartitionJob::exec()
{
    return Calamares::JobResult::error( tr( "TODO" ) );
}
