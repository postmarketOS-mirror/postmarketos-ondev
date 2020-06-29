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
import QtQuick.VirtualKeyboard 2.1

Item {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: parent.right
    width: parent.width
    height: parent.height

    TextField {
        id: password
        anchors.top: parent.top
        placeholderText: qsTr("Password")
        echoMode: TextInput.Password
        onTextChanged: validatePassword(password, passwordRepeat,
                                        errorText)
        text: config.password

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    TextField {
        id: passwordRepeat
        anchors.top: password.bottom
        placeholderText: qsTr("Password (repeat)")
        echoMode: TextInput.Password
        onTextChanged: validatePassword(password, passwordRepeat,
                                        errorText)
        text: config.password

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Text {
        id: errorText
        anchors.top: passwordRepeat.bottom
        visible: false

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }
    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: errorText.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Continue")
        onClicked: {
            if (validatePassword(password, passwordRepeat, errorText)) {
                config.password = password.text;
                navTo("install_confirm");
            }
        }
    }
}
