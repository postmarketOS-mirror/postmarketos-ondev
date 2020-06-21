/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2015, Teo Mrnjavac <teo@kde.org>
 *   Copyright 2018, Adriaan de Groot <groot@kde.org>
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

import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    function nextSlide() {
        console.log("QML Component (default slideshow) Next slide");
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 10000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {

        Image {
            id: background
            source: "wallpaper.jpg"
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
        }
        Text {
            anchors.fill: parent
            text: "Welcome to postmarketOS!<br/>"+
                  "We aim to provide a real Linux distribution for phones<br/>"+
                  "and other mobile devices.<br/>"
            wrapMode: Text.WordWrap
            font.pointSize: 24
            color: "white"
            horizontalAlignment: Text.Center
            verticalAlignment: Text.AlignBottom
            style: Text.Outline
            styleColor: "black"
        }
    }

    Slide {
        Image {
            id: background2
            source: "wallpaper.jpg"
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
        }
        Text {
            anchors.horizontalCenter: background.horizontalCenter
            text: "You can run postmarketOS with the environment of your choice<br/>"+
                  "For example the Plasma Mobile or Phosh mobile environments<br/>"+
                  "Or classic Gnome or Plasma desktop environments.<br/>"
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
        }
    }

    // When this slideshow is loaded as a V1 slideshow, only
    // activatedInCalamares is set, which starts the timer (see above).
    //
    // In V2, also the onActivate() and onLeave() methods are called.
    // These example functions log a message (and re-start the slides
    // from the first).
    function onActivate() {
        console.log("QML Component (default slideshow) activated");
        presentation.currentSlide = 0;
    }
    
    function onLeave() {
        console.log("QML Component (default slideshow) deactivated");
    }

}
