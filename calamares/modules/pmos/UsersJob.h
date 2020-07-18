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

#pragma once
#include "Job.h"


class UsersJob : public Calamares::Job
{
    Q_OBJECT
public:
    UsersJob( QString password, bool isSshEnabled, QString sshUsername,
              QString sshPassword );

    QString prettyName() const override;
    Calamares::JobResult exec() override;

    Calamares::JobList createJobs();

private:
    QString m_password;
    bool m_isSshEnabled;
    QString m_sshUsername;
    QString m_sshPassword;
};
