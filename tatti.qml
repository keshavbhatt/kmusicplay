import QtQuick 2.0;

Rectangle {
    width: 400;
    height: 300;

    ListView {
        id: listTest;
        clip: true;
        currentIndex: -1;
        model: ListModel {
            id: modelTest;

            ListElement { name: "Banana"; }
            ListElement { name: "Apple";  }
            ListElement { name: "Orange"; }
            ListElement { name: "Pear";   }
        }
        delegate: Item {
            id: item;
            height: 60;
            anchors {
                left: parent.left;
                right: parent.right;
            }

            property bool isCurrent : (model.index === listTest.currentIndex);
            onIsCurrentChanged: {
                if (isCurrent) {
                    input.forceActiveFocus ();
                }
                else {

                }
            }

            Text {
                id: label;
                font.pixelSize: 14;
                text: model.name;
                visible: !item.isCurrent;
                anchors {
                    left: parent.left;
                    right: btnUp.left;
                    margins: 20;
                    verticalCenter: parent.verticalCenter;
                }
            }
            TextInput {
                id: input;
                text: model.name;
                visible: item.isCurrent;
                onTextChanged: { modelTest.setProperty (model.index, "name", text); }
                anchors {
                    left: parent.left;
                    right: btnUp.left;
                    margins: 20;
                    verticalCenter: parent.verticalCenter;
                }

                Rectangle {
                    z: -1;
                    radius: 5;
                    antialiasing: true;
                    border {
                        width: 1;
                        color: "blue";
                    }
                    anchors {
                        fill: parent;
                        margins: -5;
                    }
                }
            }
            MouseArea {
                id: clicker;
                anchors.fill: parent;
                visible: !item.isCurrent;
                onClicked: { listTest.currentIndex = model.index; }
            }
            MouseArea {
                id: btnUp;
                width: height;
                anchors {
                    top: parent.top;
                    right: parent.right;
                    bottom: parent.verticalCenter;
                }
                onClicked: {
                    if (model.index > 0) {
                        modelTest.move (model.index, model.index -1, 1);
                    }
                }

                Text {
                    text: "V";
                    color: "gray";
                    rotation: -180;
                    anchors.centerIn: parent;
                }
            }
            MouseArea {
                id: btnDown;
                width: height;
                anchors {
                    top: parent.verticalCenter;
                    right: parent.right;
                    bottom: parent.bottom;
                }
                onClicked: {
                    if (model.index < modelTest.count -1) {
                        modelTest.move (model.index, model.index +1, 1);
                    }
                }

                Text {
                    text: "V";
                    color: "gray";
                    anchors.centerIn: parent;
                }
            }
            Rectangle {
                height: 1;
                color: "lightgray";
                anchors {
                    left: parent.left;
                    right: parent.right;
                    bottom: parent.bottom;
                }
            }
        }
        anchors.fill: parent;
    }
}
