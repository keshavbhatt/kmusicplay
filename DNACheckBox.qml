import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import "base.js" as Base


CheckBox {
    id : checkbox
  //  text: "Default DNA Radio Button"
    property string textColor : Base.Color.BlackDark
    style: CheckBoxStyle {
        indicator: Rectangle {
                implicitWidth: 20
                implicitHeight: 20
                border.color: {
                    if (checkbox.enabled == true){
                        return checkbox.checked ? Base.Color.Primary.Value : Base.Color.Disabled.Value
                    } else {
                        return Qt.lighter(Base.Color.Disabled.Value,1.1)
                    }
                }

                border.width: 4
                color : {
                    if (checkbox.enabled==true){
                        return "white"
                    } else {
                        return  checkbox.checked ? "white" : Qt.lighter(Base.Color.Disabled.Value,1.1)
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    implicitWidth: 6
                    implicitHeight: 6
                    visible: {

                            if ((checkbox.checked == true) || (checkbox.hovered==true)){
                                return true
                            }    else return false;
                    }
                    color:{
                        if (checkbox.enabled == true){
                            return checkbox.checked ? Base.Color.Primary.Value : Base.Color.Disabled.Value
                        } else {
                            Qt.lighter(Base.Color.Disabled.Value,1.1)
                        }
                    }

                }
        }
//        label : Label{
//            color : {
//             if (checkbox.enabled==true){
//                 return checkbox.textColor
//             } else {
//                 return Qt.darker(Base.Color.Disabled.Value,1.7)
//             }
//            }
//            text : checkbox.text
//            font.bold: true
//            verticalAlignment : Text.AlignVCenter
//            horizontalAlignment : Text.AlignHCenter


//        }
    }
    MouseArea { /*cursorShape: Qt.PointingHandCursor;*/ acceptedButtons: Qt.NoButton;anchors.fill: parent }
 }

