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
    const QString sshConfig = "/usr/share/postmarketos-ondev/sshd_config";

    QList< std::tuple<System::RunLocation, const QStringList, const QString> >
    commands = {
        /* Set default user password */
        { System::RunLocation::RunInTarget,
          {"passwd", "user"},
           m_password + "\n" + m_password + "\n" },

        /* Enable or disable sshd */
        { System::RunLocation::RunInTarget,
          {"rc-update", rcUpdateVerb, "sshd", "default"}, nullptr },

        /* Copy sshd_config, which disables login for default user */
        { System::RunLocation::RunInHost,
          {"cp", sshConfig, "/mnt/install/etc/ssh/sshd_config"}, nullptr },
    };

    if (m_isSshEnabled) {
        commands.append({ System::RunLocation::RunInTarget,
                          {"useradd", "-G", "wheel", "-m", m_sshUsername},
                          nullptr} );
        commands.append({ System::RunLocation::RunInTarget,
                          {"passwd", m_sshUsername},
                          m_sshPassword + "\n" + m_sshPassword + "\n"} );
        /* FIXME: Only allow this user in sshd_config - run sed? */
    }

    foreach( auto command, commands ) {
        auto location = std::get<0>(command);
        const QStringList args = std::get<1>(command);
        const QString stdInput = std::get<2>(command);
        const QString pathRoot = "/";

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
