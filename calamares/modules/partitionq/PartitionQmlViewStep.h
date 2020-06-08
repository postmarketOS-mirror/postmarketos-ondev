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

#ifndef PARTITION_QMLVIEWSTEP_H
#define PARTITION_QMLVIEWSTEP_H

#include "utils/PluginFactory.h"
#include "viewpages/QmlViewStep.h"

#include <DllMacro.h>

#include <QObject>
#include <QVariantMap>

namespace CalamaresUtils
{
namespace GeoIP
{
class Handler;
}
}  // namespace CalamaresUtils

class GeneralRequirements;

class PartitionQmlViewStepPass : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText)
public:
    QString text() const { return m_text; }
    void setText(const QString &text) {
        m_text = text;
    }

private:
    QString m_text;
};


// TODO: Needs a generic Calamares::QmlViewStep as base class
// TODO: refactor and move what makes sense to base class
class PLUGINDLLEXPORT PartitionQmlViewStep : public Calamares::QmlViewStep
{
    Q_OBJECT

public:
    explicit PartitionQmlViewStep( QObject* parent = nullptr );

    QString prettyName() const override;

    bool isNextEnabled() const override;
    bool isBackEnabled() const override;

    bool isAtBeginning() const override;
    bool isAtEnd() const override;

    Calamares::JobList jobs() const override;

    void setConfigurationMap( const QVariantMap& configurationMap ) override;

    void onLeave();
private:
    PartitionQmlViewStepPass *m_pass;
};

CALAMARES_PLUGIN_FACTORY_DECLARATION( PartitionQmlViewStepFactory )

#endif  // PARTITION_QMLVIEWSTEP_H
