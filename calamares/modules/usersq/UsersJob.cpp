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


UsersJob::UsersJob( QString password, bool isSshEnabled, QString sshUsername,
                    QString sshPassword )
    : Calamares::Job()
    , m_password (password)
    , m_isSshEnabled (isSshEnabled)
    , m_sshUsername (sshUsername)
    , m_sshPassword (sshPassword)
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
    using namespace CalamaresUtils;
    using namespace std;

    const QString rcUpdateVerb = m_isSshEnabled ? "add" : "del";

    QList< QPair<const QStringList, const QString> > commands = {
        { {"passwd", "user"}, m_password + "\n" + m_password + "\n" },
        { {"rc-update", rcUpdateVerb, "sshd", "default"}, nullptr },
    };

    if (m_isSshEnabled) {
        commands.append({{"useradd", "-G", "wheel", "-m", m_sshUsername},
                         nullptr} );
        commands.append({{"passwd", m_sshUsername},
                         m_sshPassword + "\n" + m_sshPassword + "\n"} );
    }

    foreach( auto command, commands ) {
        auto location = System::RunLocation::RunInTarget;
        const QString pathRoot = "/";
        const QStringList args = command.first;
        const QString stdInput = command.second;

        ProcessResult res = System::runCommand( location, args, pathRoot,
                                                stdInput,
                                                chrono::seconds( 30 ));
        if ( res.getExitCode() ) {
            return JobResult::error( "Command failed:<br><br>"
                                     "'" + args.join(" ") + "'<br><br>"
                                     " with output:<br><br>"
                                     "'" + res.getOutput() + "'");
        }
    }

    return JobResult::ok();
}
