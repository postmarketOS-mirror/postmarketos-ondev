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
    id: welcome

    Item {
        id: appContainer
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        Item {
            width: parent.width
            height: parent.height

            Image {
                id: logo
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 100
                width: 300
                fillMode: Image.PreserveAspectFit
                source: "img/postmarketos3d.png"
            }
            Text {
                id: welcomeText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: logo.bottom
                anchors.topMargin: 30
                horizontalAlignment: Text.AlignRight
                text: "You are about to install<br>" +
                      "postmarketOS " +
                      "<b>" + config.version + "</b><br>" +
                      "user interface " +
                      "<b>" + pretty_ui(config.userInterface) + "</b><br>" +
                      "architecture " +
                      "<b>" + config.arch + "</b><br>" +
                      "on your " +
                      "<b>" + config.device + "</b><br>"
                width: Math.min(parent.width / 1.5, 300)
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: welcomeText.bottom
                anchors.topMargin: 40
                width: Math.min(parent.width / 1.5, 300)

                text: qsTr("Continue")
                onClicked: ViewManager.next()
            }
        }
    }
    function pretty_ui(name) {
        /* Translate the UI value from "pmbootstrap config ui", which is the
         * suffix of the postmarketos-ui-* pkgnames, to the pretty name. This
         * defaults to just displaying the original name, if we don't have a
         * pretty name specified in the map below. */
        var map = {
            "fbkeyboard": "fbkeyboard",
            "gnome": "GNOME",
            "i3wm": "i3",
            "kodi": "Kodi",
            "mate": "MATE",
            "phosh": "Phosh",
            "plasma-desktop": "Plasma Desktop",
            "plasma-mobile": "Plasma Mobile",
            "plasma-mobile-extra": "Plasma Mobile",
            "shelli": "Shelli",
            "sway": "Sway",
            "weston": "Weston",
            "xfce4": "Xfce 4",
        }
        return map[name] ? map[name] : name;
    }
}
