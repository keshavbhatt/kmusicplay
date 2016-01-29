import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0
import "base.js" as Base

Rectangle{
    id : switchButton
    implicitHeight: 25
    implicitWidth: 60

    property string type : "Default"
    property color bgColor
    property color bgColorLight
    property color bgColorDark
    property string onText : "ON "
    property string offText : "OFF"
    property bool onState : false
    property alias on : switchButton.onState
    property bool __firstTime : true

    property int transitionDuration : 300

    radius : switchButton.implicitHeight/2
    border.width: 2

    function getDefaultColor(){
        if (type == "Custom"){
            return bgColor;
        } else return Base.Color[type].Value
    }
    Label {
        id : label
        font.bold : true
        font.pointSize: 9
        anchors.verticalCenter : parent.verticalCenter
    }
    Rectangle{
        id : handle
        implicitWidth: parent.implicitHeight - 6
        implicitHeight: parent.implicitHeight - 6
        radius : (parent.implicitHeight - 6)/2
        anchors.verticalCenter: parent.verticalCenter
    }
    states : [
        State {
            name : "onState"
            when : switchButton.onState
            PropertyChanges {target: switchButton;color : switchButton.bgColor}
            PropertyChanges {target: switchButton;border.color: switchButton.bgColor}
            AnchorChanges {target: handle;anchors.right: switchButton.right}
            AnchorChanges {target: handle;anchors.left: undefined}
            PropertyChanges {target: handle;anchors.rightMargin: 3}
            PropertyChanges {target: handle;color: "white"}
            PropertyChanges {target: label;text : switchButton.onText}
            AnchorChanges {target: label;anchors.left : switchButton.left}
            AnchorChanges {target: label;anchors.right : undefined}
            PropertyChanges {target: label;anchors.leftMargin : 10}
            PropertyChanges {target: label;color : "white"}
        },
        State {
            name : "offState"
            when : !(switchButton.onState) && (switchButton.__firstTime == false)
            PropertyChanges {target: switchButton;color : Base.Color.White}
            PropertyChanges {target: switchButton;border.color: switchButton.bgColor}
            AnchorChanges {target: handle;anchors.left: switchButton.left}
            AnchorChanges {target: handle;anchors.right: undefined}
            PropertyChanges {target: handle;anchors.leftMargin: 4}
            PropertyChanges {target: handle;color: switchButton.bgColor}
            PropertyChanges {target: label;text : switchButton.offText}
            AnchorChanges {target: label;anchors.right : switchButton.right}
            AnchorChanges {target: label;anchors.left : undefined}
            PropertyChanges {target: label;anchors.rightMargin : 10}
            PropertyChanges {target: label;anchors.leftMargin : 0}
            PropertyChanges {target: label;color : switchButton.bgColorDark}
        },
        State {
            name : "offStateHovered"
            PropertyChanges {target: switchButton;color : Base.Color.White}
            PropertyChanges {target: switchButton;border.color: Base.Color.Disabled.Value}
            AnchorChanges {target: handle;anchors.left: switchButton.left}
            AnchorChanges {target: handle;anchors.right: undefined}
            PropertyChanges {target: handle;anchors.leftMargin: 4}
            PropertyChanges {target: handle;color: Base.Color.Disabled.Dark}
            PropertyChanges {target: label;text : switchButton.offText}
            AnchorChanges {target: label;anchors.right : switchButton.right}
            AnchorChanges {target: label;anchors.left : undefined}
            PropertyChanges {target: label;anchors.rightMargin : 10}
            PropertyChanges {target: label;color : Base.Color.Black}
        },
        State {
            name : "onStateHovered"
            PropertyChanges {target: switchButton;color : switchButton.bgColorLight}
            PropertyChanges {target: switchButton;border.color: switchButton.bgColorLight}
            AnchorChanges {target: handle;anchors.right: switchButton.right}
            AnchorChanges {target: handle;anchors.left: undefined}
            PropertyChanges {target: handle;anchors.rightMargin: 3}
            PropertyChanges {target: handle;color: "white"}
            PropertyChanges {target: label;text : switchButton.onText}
            AnchorChanges {target: label;anchors.left : switchButton.left}
            AnchorChanges {target: label;anchors.right : undefined}
            PropertyChanges {target: label;anchors.leftMargin : 10}
            PropertyChanges {target: label;color : "white"}
        },
        State {
            // The switch is disable while being at "ON" state
            name : "onDisabledState"
            PropertyChanges {target: switchButton;color : Base.Color.Disabled.Value}
            PropertyChanges {target: switchButton;border.color: Base.Color.Disabled.Value}
            PropertyChanges {target: switchButton;border.width: 2}
            AnchorChanges {target: handle;anchors.right: switchButton.right}
            AnchorChanges {target: handle;anchors.left: undefined}
            PropertyChanges {target: handle;anchors.rightMargin: 3}
            PropertyChanges {target: handle;color: "white"}
            PropertyChanges {target: label;text : switchButton.onText}
            AnchorChanges {target: label;anchors.left : switchButton.left}
            AnchorChanges {target: label;anchors.right : undefined}
            PropertyChanges {target: label;anchors.leftMargin : 10}
            PropertyChanges {target: label;color : "white"}
        }
        ,
        State {
            // offStateActive runs only once when its value is off.
            // offStateActive and offStateHovered are exactly the same
            name : "offStateActive"
            when : (switchButton.__firstTime == true) && (switchButton.onState==false)
            PropertyChanges {target: switchButton;color : Base.Color.White}
            PropertyChanges {target: switchButton;border.color: Base.Color.Disabled.Value}
            AnchorChanges {target: handle;anchors.left: switchButton.left}
            AnchorChanges {target: handle;anchors.right: undefined}
            PropertyChanges {target: handle;anchors.leftMargin: 3}
            PropertyChanges {target: handle;color: Base.Color.Disabled.Dark}
            PropertyChanges {target: label;text : switchButton.offText}
            AnchorChanges {target: label;anchors.right : switchButton.right}
            AnchorChanges {target: label;anchors.left : undefined}
            PropertyChanges {target: label;anchors.rightMargin : 10}
            PropertyChanges {target: label;color : Base.Color.Black}
        }

    ]

    transitions: [
        Transition {
            from : "offState"
            to : "onState"
            ParallelAnimation{
                ColorAnimation { duration: switchButton.transitionDuration }
                AnchorAnimation { duration: switchButton.transitionDuration  }
            }

        },
        Transition {
            from : "*"
            to : "offState"
            ParallelAnimation{
                ColorAnimation { duration: switchButton.transitionDuration  }
                AnchorAnimation { duration: switchButton.transitionDuration  }
            }

        },
        Transition {
            // when mouse leaves
            from : "onState"
            to : "onStateHovered"
            reversible: true
            ColorAnimation { duration: switchButton.transitionDuration  }
        }

    ]

    MouseArea {
        id : behaviour
        anchors.fill : parent
       // cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            if (enabled) {
                if (switchButton.state=="offStateHovered" || switchButton.state=="offStateActive"){
                    switchButton.state = "offState"
                }
                if (switchButton.state=="onState"){
                    switchButton.state = "onStateHovered"
                }
            }
        }

        onCanceled : {
            switchButton.__firstTime = false
            if (enabled) {
                if ((!behaviour.pressed) && (switchButton.onState==false)) {
                    switchButton.state = "offStateHovered"
                }
                if ((!behaviour.pressed) && (switchButton.onState==true)) {
                    switchButton.state = "onState"
                }
            }
        }
        onExited : {
            switchButton.__firstTime = false
            if (enabled) {
                if ((!behaviour.pressed) && (switchButton.onState==false)) {
                    switchButton.state = "offStateHovered"
                }
                if ((!behaviour.pressed) && (switchButton.onState==true)) {
                    switchButton.state = "onState"
                }
            }
        }

        onPressed: {
            if (enabled) {
                switchButton.__firstTime = false
                switchButton.onState = !switchButton.onState
            }
        }
    }

    Component.onCompleted: {

        if (type !== "Custom"){
            bgColor = Base.Color[type].Value;
            bgColorLight = Base.Color[type].Light;
            bgColorDark = Base.Color[type].Dark;
        } else {
            bgColorLight = Qt.lighter(color,1.2);
            bgColorDark = Qt.darker(color,1.2);
        }

        if (switchButton.enabled==false){
            if (onState) {
                // onDisabledState is the state that the witch has "ON" value and the interaction is disabled
                switchButton.state = "onDisabledState"
            }
        }
    }
}
