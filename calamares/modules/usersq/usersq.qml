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

Page
{
    id: usersq

    property var screen: "default_name"
    property var screenPrevious: []
    property var titles: {
        "default_name": "Username",
        "default_pin": "Lockscreen PIN",
        "ssh_confirm": "SSH server",
        "ssh_credentials": "SSH credentials",
    }

    Item {
        id: appContainer
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: inputPanel.top
        Item {
            width: parent.width
            height: parent.height

            Rectangle {
                id: mobileNavigation
                width: parent.width
                height: 40
                color: "#e6e4e1"
                Layout.fillWidth: true

                border.width: 1
                border.color: "#a7a7a7"

                anchors.left: parent.left
                anchors.right: parent.right

                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: 6

                    Button {
                        Layout.leftMargin: 6
                        id: mobileBack
                        text: "<"

                        background: Rectangle {
                            implicitWidth: 32
                            implicitHeight: 30
                            border.color: "#c1bab5"
                            border.width: 1
                            radius: 4
                            color: mobileBack.down ? "#dbdbdb" : "#f2f2f2"
                        }

                        onClicked: navBack()
                    }
                    Text {
                        id: mobileTitle
                        text: "<b>Title text</b>"
                        color: "#303638"
                    }
                }
            }

            Loader {
                id: load
                anchors.left: parent.left
                anchors.top: mobileNavigation.bottom
                anchors.right: parent.right
            }
        }
    }
    InputPanel {
        id: inputPanel
        y: Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
        anchors.left: parent.left
        anchors.right: parent.right
    }

    /* Navigation related */
    function navTo(name, historyPush=true) {
        if (historyPush)
            screenPrevious.push(screen);
        screen = name;
        load.source = name + ".qml";
        mobileTitle.text = "<b>" + titles[name] + "</b>";
        Qt.inputMethod.hide();

        /* Restore input */
        switch (name) {
            case "default_name":
                username.Text = config.username;
                break;
        }
    }
    function navFinish() {
        ViewManager.next();
    }
    function navBack() {
        if (screenPrevious.length)
            return navTo(screenPrevious.pop(), false);
        ViewManager.back();
    }
    function onActivate() {
        navTo(screen, false);
    }

    /* Input verification */
    function validationFailure(errorText, message="") {
        errorText.text = message;
        errorText.visible = true;
        return false;
    }
    function validationFailureClear(errorText) {
        errorText.text = "";
        errorText.visible = false;
        return true;
    }
    function validateUsername(username, errorText, reservedAdditional="") {
        var name = username.text;
        config.username = name;

        /* Validate characters */
        for (var i=0; i<name.length; i++) {
            if (i) {
                if (!name[i].match(/^[a-z0-9_-]$/))
                    return validationFailure(errorText,
                                             "Characters must be lowercase" +
                                             " letters, numbers,<br>" +
                                             " underscores or minus signs.");
            } else {
                if (!name[i].match(/^[a-z_]$/))
                    return validationFailure(errorText,
                                             "First character must be a" +
                                             " lowercase letter or an" +
                                             " underscore.");
            }
        }

        /* TODO: validate against reserved usernames */

        /* Passed */
        return validationFailureClear(errorText);
    }
    function validatePin(userPin, userPinRepeat, errorText) {
        var pin = userPin.text;
        var repeat = userPinRepeat.text;

        if (pin == "")
            return validationFailure(errorText);

        if (!pin.match(/^[0-9]*$/))
            return validationFailure(errorText,
                                     "Only digits are allowed.");

        if (pin.length < 5)
            return validationFailure(errorText,
                                     "Too short: needs at least 5 digits.");

        if (repeat == "")
            return validationFailure(errorText);

        if (repeat != pin)
            return validationFailure(errorText,
                                     "The PINs don't match.");
                             
        return validationFailureClear(errorText);
    }
    function validateSshUsername(username, errorText) {
        /* FIXME: put default user's name here */
        var reservedAdditional = "user";

        return validateUsername(username, errorText, reservedAdditional);
    }
    function validateSshPassword(password, passwordRepeat, errorText) {
        var pass = password.text;
        var repeat = passwordRepeat.text;

        if (pass == "")
            return validationFailure(errorText);

        if (pass.length < 8)
            return validationFailure(errorText,
                                     "Too short: needs at least 8" +
                                     " characters.");

        if (repeat == "")
            return validationFailure(errorText);

        if (pass != repeat)
            return validationFailure(errorText, "Passwords don't match.");

        return validationFailureClear(errorText);
    }
}
