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
        id: description
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        wrapMode: Text.WordWrap

        text: "Set the numeric password of your user. The lockscreen will" +
              "ask for this PIN. This is <i>not</i> the PIN of your SIM" +
              "card. Make sure to remember it."

        width: 500
    }

    TextField {
        id: userPin
        anchors.top: description.bottom
        placeholderText: qsTr("PIN")
        echoMode: TextInput.Password
        onTextChanged: validatePin(userPin, userPinRepeat, errorText)
        text: config.password

        /* Let the virtual keyboard change to digits only */
        inputMethodHints: Qt.ImhDigitsOnly
        onActiveFocusChanged: {
            if(activeFocus) {
                Qt.inputMethod.update(Qt.ImQueryInput)
            }
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    TextField {
        id: userPinRepeat
        anchors.top: userPin.bottom
        placeholderText: qsTr("PIN (repeat)")
        inputMethodHints: Qt.ImhDigitsOnly
        echoMode: TextInput.Password
        onTextChanged: validatePin(userPin, userPinRepeat, errorText)
        text: config.password

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Text {
        anchors.top: userPinRepeat.bottom
        id: errorText
        visible: false
        wrapMode: Text.WordWrap

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
            if (validatePin(userPin, userPinRepeat, errorText)) {
                config.password = userPin.text;
                navTo("ssh_confirm");
            }
        }
    }
}
