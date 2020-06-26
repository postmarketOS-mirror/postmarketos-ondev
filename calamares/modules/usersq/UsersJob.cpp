/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2020, Oliver Smith <ollieparanoid@postmarketos.org>
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

#include "UsersJob.h"

#include "GlobalStorage.h"
#include "JobQueue.h"
#include "Settings.h"
#include "utils/CalamaresUtilsSystem.h"
#include "utils/Logger.h"

#include <QDir>
#include <QFileInfo>


UsersJob::UsersJob( bool isFdeEnabled, const QString& password )
    : Calamares::Job()
    , m_isFdeEnabled ( isFdeEnabled )
    , m_password ( password )
{
}


QString
UsersJob::prettyName() const
{
    return "Configuring users";
}

Calamares::JobResult
UsersJob::exec()
{
    using namespace Calamares;

    /* TODO */
    return JobResult::ok();
}
