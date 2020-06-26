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
    using namespace Calamares;
    using namespace CalamaresUtils;
    using namespace std;

    const QString pathRoot = "/";
    const QString pathMount = "/mnt/install";
    const QString ext4Opts = "^metadata_csum,^huge_file";
    const QString ext4Label = "pmOS_root";
    const QString cryptName = "calamares_crypt";
    QString cryptDev = "/dev/mapper/" + cryptName;
    QString passwordStdin = m_password + "\n";

    /* Partition selection is not implemented yet, let ondev-boot.sh pass it */
    QString dev = getenv("ONDEV_PARTITION_TARGET");
    if (dev == nullptr)
        return JobResult::error( "Missing ONDEV_PARTITION_TARGET" );

    QList< QPair<const QStringList, const QString> > commands = {
        {{"mkdir", "-p", pathMount}, nullptr},
    };

    if ( m_isFdeEnabled ) {
        commands.append({
            {{"cryptsetup", "luksFormat", "--use-urandom", dev}, passwordStdin},
            {{"cryptsetup", "luksOpen", dev, cryptName}, passwordStdin},
            {{"mkfs.ext4", "-O", ext4Opts, "-L", ext4Label, cryptDev}, nullptr},
            {{"mount", cryptDev, pathMount}, nullptr}
        });
    } else {
        commands.append({
            {{"mkfs.ext4", "-O", ext4Opts, "-L", ext4Label, dev}, nullptr},
            {{"mount", dev, pathMount}, nullptr}
        });
    }

    foreach( auto command, commands ) {
        const QStringList args = command.first;
        const QString stdInput = command.second;

        ProcessResult res = System::runCommand( System::RunLocation::RunInHost,
                                                args, pathRoot, stdInput,
                                                chrono::seconds( 120 ) );
        if ( res.getExitCode() ) {
            return JobResult::error( "Command failed:<br><br>"
                                     "'" + args.join(" ") + "'<br><br>"
                                     " with output:<br><br>"
                                     "'" + res.getOutput() + "'");
        }
    }

    /* FIXME: now fill global storage */

    return JobResult::ok();
}
