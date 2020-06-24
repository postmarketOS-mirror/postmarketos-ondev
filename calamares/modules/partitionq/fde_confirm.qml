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

        text: "To protect your data in case your device gets stolen," +
              " it is recommended to enable full disk encryption.<br>" +
              "<br>" +
              "If you enable full disk encryption, you will be asked for" +
              " a password. Without this password, it is not possible to" +
              " boot your device or access any data on it. Make sure that" +
              " you don't lose this password!"

        width: 500
    }

    Button {
        id: enableButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: welcomeText.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Enable")
        onClicked: {
            config.isFdeEnabled = true;
            navTo("fde_pass");
        }
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: enableButton.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Disable")
        onClicked: {
            config.isFdeEnabled = false;
            navTo("install_confirm");
        }
    }
}
