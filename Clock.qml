
import QtQuick 2.0

Item {
    id : clock
    width: 200

    height:  200
    property int anglee: secondRotation.angle


        Image {
id:volmkey
            x: 97.5; y: 20
            source: "second.png"
            transform: Rotation {
                id: secondRotation
                origin.x: 2.5; origin.y: 80;
                 angle: anglee
                Behavior on angle {
                    SpringAnimation { spring: 5; damping: 0.2; modulus: 360 }
                }


            }
        }




}
