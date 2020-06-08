/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2020, Adriaan de Groot <groot@kde.org>
 *   Copyright 2020, Anke Boersma <demm@kaosx.us>
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
import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3

Page
{
    id: partition

    header: Item {
        width: parent.width
        height: parent.height

        Text {
            id: luksSimpleTopText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            padding: 40
            text: qsTr("<h3>Full disk encryption</h3>")
            width: Math.min(parent.width / 1.5, 500)
        }

        TextField {
            id: luksPass
            anchors.top: luksSimpleTopText.bottom
            placeholderText: qsTr("Password")
            onTextChanged: {
                pass.text = text;
                passwordError.visible = false;
            }

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 50
            padding: 40
            echoMode: TextInput.Password
            width: Math.min(parent.width / 1.5, 500)
        }

        TextField {
            id: luksPassRepeat
            anchors.top: luksPass.bottom
            placeholderText: qsTr("Password (repeat)")
            onTextChanged: {
                passwordError.visible = false;
            }

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 50
            padding: 40
            echoMode: TextInput.Password
            width: Math.min(parent.width / 1.5, 500)
        }

        Text {
            anchors.top: luksPassRepeat.bottom
            id: passwordError
            visible: false

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 50
            padding: 40
            width: Math.min(parent.width / 1.5, 500)
        }

        Button {
            id: luksPassContinue
            anchors.top: passwordError.bottom
            text: qsTr("Continue")

	    onClicked: {
                passwordError.text = qsTr("");
                passwordError.visible = true;

                if (luksPass.text !== luksPassRepeat.text) {
                    passwordError.text = qsTr("Passwords do not match");
                } else if (luksPass.text.length < 5) {
                    passwordError.text = qsTr("Password too short");
                } else {
                    luksPassContinue.text = qsTr("Please wait...")
                    luksPassContinue.enabled = false
                    /* Let PartitionQmlViewStep.cpp::onLeave() create the
                       encrypted partition and mount it. */
                    ViewManager.next();
                }
            }

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 50
            padding: 40
            width: Math.min(parent.width / 1.5, 500)
        }
        Loader {
            id:load
            anchors.fill: parent
        }
    }
}