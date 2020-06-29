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
import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.VirtualKeyboard 2.1

Item {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: parent.right
    width: parent.width
    height: parent.height

    Text {
        id: welcomeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        wrapMode: Text.WordWrap

        text: "If you don't know what SSH is, choose 'disable'.<br>" +
              "<br>" +
              "With 'enable', you will be asked for a second username<br>" +
              "and password. You will be able to login to the SSH server<br>" +
              "with these credentials via USB (172.16.42.1), Wi-Fi and<br>" +
              "possibly cellular network. It is recommended to replace<br>" +
              "the password with an SSH key after the installation. Find<br>" +
              "more information at: https://postmarketos.org/ssh"

        width: 500
    }

    Button {
        id: enableButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: welcomeText.bottom
        anchors.topMargin: 40
        width: 500
        padding: 50

        text: qsTr("Enable")
        onClicked: {
            config.isSshEnabled = true;
            navTo("ssh_credentials");
        }
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: enableButton.bottom
        anchors.topMargin: 40
        width: 500
        padding: 50

        text: qsTr("Disable")
        onClicked: {
            config.isSshEnabled = false;
            navFinish();
        }
    }
}
