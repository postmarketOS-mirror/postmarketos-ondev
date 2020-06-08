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
    Calamares::QmlViewStep::setConfigurationMap( configurationMap );
    m_pass = new PartitionQmlViewStepPass();
    setContextProperty( "pass", m_pass );
}

PartitionQmlViewStep::PartitionQmlViewStep( QObject* parent )
    : Calamares::QmlViewStep( parent )
{
}

/* Similar to modules/partition/jobs/FillGlobalStorageJob */
void
FillGlobalStorage(const char *mountpoint)
{
    Calamares::GlobalStorage* gs = Calamares::JobQueue::instance()->globalStorage();
    QVariantList partitions;
    QVariantMap partition;

    /* See mapForPartition() */
    partition[ "device"] = "/dev/mapper/pm_crypt";
    partition[ "mountPoint" ] = "/";
    partition[ "fsName" ] = "ext4";
    partition[ "fs" ] = "ext4";
    partition[ "uuid" ] = ""; /* FIXME */
    partition[ "claimed" ] = true;

    partitions << partition;
    gs->insert( "partitions", partitions);
    gs->insert( "rootMountPoint", mountpoint);
}

void
PartitionQmlViewStep::onLeave()
{
    /* Partition selection is not implemented yet, let ondev-boot.sh pass it */
    const char *dev = getenv("ONDEV_PARTITION_TARGET");
    std::string pass_str = m_pass->text().toStdString();
    const char *pass = pass_str.c_str();
    const char *dev_crypt = "pm_crypt";
    const char *dev_crypt_path = "/dev/mapper/pm_crypt";
    const char *ext4_opts = "^metadata_csum,^huge_file";
    const char *label = "pmOS_root";
    const char *mountpoint = "/mnt/install";
    QProcess process;

    cDebug() << "Running: cryptsetup luksFormat" << dev;
    process.start( "cryptsetup", { "luksFormat", dev } );
    process.write(pass, qstrlen(pass));
    process.write("\n", 1);
    process.waitForFinished();

    cDebug() << "Running: cryptsetup luksOpen" << dev << dev_crypt;
    process.start( "cryptsetup", { "luksOpen", dev, dev_crypt } );
    process.write(pass, qstrlen(pass));
    process.write("\n", 1);
    process.waitForFinished();

    cDebug() << "Running: mkfs.ext4 -O" << ext4_opts << "-L" << label << dev_crypt_path;
    process.start( "mkfs.ext4", {"-O", ext4_opts, "-L", label, dev_crypt_path} );
    process.waitForFinished();

    cDebug() << "Running: mkdir -p" << mountpoint;
    process.start( "mkdir", { "-p", mountpoint } );
    process.waitForFinished();

    cDebug() << "Running: mount" << dev_crypt_path << mountpoint;
    process.start( "mount", { dev_crypt_path, mountpoint } );
    process.waitForFinished();

    FillGlobalStorage(mountpoint);
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
    return Calamares::JobList();
}
