import QtQuick 2.0

import QtGraphicalEffects 1.0

Rectangle {
    color: "transparent"
    id: mainview
    width: parent.width /*activerec2 ? 200 : 0*/
    height: (parent.height) - (playactrl2.height + playactrl.height)
    opacity: 0.7
    property bool activerec2: false

    //setting rectangle inside palyer tab
    Rectangle {

        id: settingRec
        width: parent.width /*activerec2 ? 200 : 0*/
        height: parent.height
        color: "#2D2D2D"
        opacity: activerec2 ? 0 : 1
        RectangularGlow {

            anchors.fill: parent
            glowRadius: 4
            spread: 0.1
            color: "#2D2D2D"
            cornerRadius: parent.radius + glowRadius
        }
        MouseArea {
            id: toogler
            anchors.fill: parent
            hoverEnabled: true
            onWheel: {
                mainWindow.header.visible = true
            }
        }
        scale: toogler.pressed && toogler.containsMouse ? 0.8 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuad
            }
        }
        // The model:
        ListModel {
            id: frModel

            ListElement {
                //               name: "Here you can save your Music Folders ";
                count: 0
                //                hits:0
                attributes: [
                    ListElement {
                        description: "Folder name"
                    }
                    //  , ListElement { description: "(test)" }
                ]
            }
        }

        // The delegate for each item in the model:
        Component {
            id: listDelegate

            Item {
                id: delegateItem
                width: listView.width
                height: 55
                clip: true

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    // index changer code if wan move item up down
                    //                    Column {
                    //                        Image {
                    //                            source: "arrow-up.png"
                    //                            MouseArea { anchors.fill: parent; onClicked: frModel.move(index, index-1, 1) }
                    //                        }
                    //                        Image { source: "arrow-down.png"
                    //                            MouseArea { anchors.fill: parent; onClicked: frModel.move(index, index+1, 1) }
                    //                        }
                    //                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter

                        //                        TextEdit {
                        //                            text:
                        //                            font.pixelSize: 15
                        //                            color: "white"
                        //                        }
                        Row {
                            spacing: 5
                            Repeater {
                                model: attributes
                                Text {
                                    id: savedfodlers
                                    text: description
                                    color: "White"

                                    MouseArea {
                                        anchors.fill: parent
                                        drag.target: parent
                                        drag.axis: Drag.XAxis
                                        onClicked: {
                                            console.log("loading.... " + savedfodlers.text)
                                            folderModel.folder = savedfodlers.text
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    spacing: 10

                    Text {
                        id: costText
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'items : ' + Number(count)
                        font.pixelSize: 13
                        color: "white"
                        font.bold: true
                    }

                    Image {
                        source: "list-delete.png"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: frModel.remove(index)
                        }
                    }
                }


                // Animate adding and removing of items:
                ListView.onAdd: SequentialAnimation {
                    PropertyAction {
                        target: delegateItem
                        property: "height"
                        value: 0
                    }
                    NumberAnimation {
                        target: delegateItem
                        property: "height"
                        to: 55
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }

                ListView.onRemove: SequentialAnimation {
                    PropertyAction {
                        target: delegateItem
                        property: "ListView.delayRemove"
                        value: true
                    }
                    NumberAnimation {
                        target: delegateItem
                        property: "height"
                        to: 0
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }

                    // Make sure delayRemove is set back to false so that the item can be destroyed
                    PropertyAction {
                        target: delegateItem
                        property: "ListView.delayRemove"
                        value: false
                    }
                }

                MouseArea {
                    id: folderSetter

                    onClicked: {

                    }
                }
            }
        }
        // The view:
        ListView {
            id: listView
            anchors.fill: parent
            anchors.topMargin: mainWindow.header.height
            anchors.leftMargin: 30
            anchors.bottomMargin: 95
            model: frModel
            delegate: listDelegate
        }

        Row {
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 30
            }
            spacing: 10

            TextButton {
                text: "Open"
                onClicked: {
                    fileDialogAideo.open()
                    activerec2 = false
                    settingRecEvo.x = activerec2 ? parent.width : 0
                }
            }

            TextButton {
                text: "Add  to library"
                onClicked: {
                    frModel.append({
                                       count: items,

                                       attributes: [
                                           { description: getSetting("mySetting") }

                                           //, {"description": "mess"}
                                       ]
                                   })
                }
            }

            TextButton {
                text: "Remove from library"
                onClicked: frModel.clear()
            }
            TextButton {
                text: "Back"
                onClicked: {
                    activerec2 = false
                    settingRecEvo.x = activerec2 ? parent.width : 0
                }
            }
        }
    }

    //setting rectangle inside palyer tab

    //setting rectangle evoker
    Rectangle {
        id: settingRecEvo
        width: 10
        height: parent.height
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter

        //   z: activerec2 ? 10000 : 1000
        radius: 1
        y: 2
        //  opacity: 0.7
        Image {
            id: damnbrkr
            width: 10
            height: parent.height
            fillMode: Image.TileVertically
            verticalAlignment: Image.AlignLeft
            source: "breaker.png"
        }

        //   signal toggled
        MouseArea {
            id: evoRecmouse
            anchors.fill: parent
            onClicked: {

                activerec2 = !activerec2

                //                settingRecEvo.toggled()

                // settingRec.z = activerec2 ? 10000 : 0
                settingRecEvo.x = activerec2 ? parent.width : 0

                // settingRec.visible = activerec2 ? true : false
                console.log(activerec2)
            }
        }
        PropertyAnimation {
            running: activerec2 ? true : false
            id: animationShow
            easing.type: Easing.OutQuint
            duration: 900
            target: settingRec
            property: "width"
            to: parent.width
            from: 0
        }
        PropertyAnimation {
            running: activerec2 ? false : true
            id: animationShowrte
            easing.type: Easing.OutQuint
            duration: 900
            target: settingRec
            property: "width"
            to: 0
            from: parent.width
        }
        PropertyAnimation {
            running: activerec2 ? true : false
            id: animationShow2
            easing.type: Easing.Linear
            duration: 900
            target: settingRec
            property: "opacity"
            to: 1
            from: 0
        }
        PropertyAnimation {
            running: activerec2 ? false : true
            id: animationShow24
            easing.type: Easing.Linear
            duration: 900
            target: settingRec
            property: "opacity"
            to: 0
            from: 1
        }

        Behavior on x {
            NumberAnimation {
                duration: 900
                easing.type: Easing.OutQuint
            }
        }

        scale: evoRecmouse.pressed && evoRecmouse.containsMouse ? 0.9 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutQuad
            }
        }

        transitions: Transition {
            NumberAnimation {
                properties: "height"
                duration: 6000
                easing.type: Easing.OutQuint
            }
        }
    }
    //end setting rectangle evoker
}
