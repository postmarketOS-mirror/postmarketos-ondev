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

Page
{
    id: partition

    property var screen: "fde_confirm"
    property var screenPrevious: []
    property var titles: {
        "fde_confirm": "Full disk encryption",
        "fde_pass": "Full disk encryption",
        "install_confirm": "Ready to install",
    }
    /* Only allow characters, that can be typed in with the postmarketOS
     * initramfs on-screen keyboard (osk-sdl, see src/keyboard.cpp).
     * FIXME: move to config file */
     property var allowed_chars:
        /* layer 0 */ "abcdefghijklmnopqrstuvwxyz" +
        /* layer 1 */ "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        /* layer 2 */ "1234567890" + "@#$%&-_+()" + ",\"':;!?" +
        /* layer 3 */ "~`|·√πτ÷×¶" + "©®£€¥^°*{}" + "\\/<>=[]" +
        /* bottom row */ " ."

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
                height: 60
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
                    Rectangle {
                        implicitHeight: 30
                        Layout.fillWidth: true
                        color: "#e6e4e1"

                        Text {
                            id: mobileTitle
                            text: ""
                            color: "#303638"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Rectangle {
                        color: "#e6e4e1"
                        Layout.rightMargin: 6
                        implicitWidth: 32
                        implicitHeight: 30
                        id: filler
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

    Timer {
        id: timer
    }

    /* Navigation related */
    function navTo(name, historyPush=true) {
        if (historyPush)
            screenPrevious.push(screen);
        screen = name;
        load.source = name + ".qml";
        mobileTitle.text = "<b>" + titles[name] + "</b>";
	Qt.inputMethod.hide();
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

    /* String formatting */
    function allowed_chars_multiline() {
        /* return allowed_chars split across multiple lines */
        var step = 20;
        var ret = "";
        for (var i = 0; i < allowed_chars.length + step; i += step)
            ret += allowed_chars.slice(i, i + step) + "\n";
        return ret.trim();
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
    function check_chars(input) {
        for (var i = 0; i < input.length; i++) {
            if (allowed_chars.indexOf(input[i]) == -1)
                return false;
        }
        return true;
    }
    function validatePassword(password, passwordRepeat, errorText) {
        var pass = password.text;
        var repeat = passwordRepeat.text;

        if (pass == "")
            return validationFailure(errorText);

        if (!check_chars(pass))
            return validationFailure(errorText,
                                     "The password must only contain\n" +
                                     "these characters, others cannot be\n" +
                                     "typed in at boot time:\n" +
                                     "\n" +
                                     allowed_chars_multiline());

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
