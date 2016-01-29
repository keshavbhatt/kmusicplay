/* Copyright (C)2015 Ktechpit.org - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Code is property of Keshav Bhatt <keshavnrj@gmail.com>, and is part of his project <Kmusicplay>
 * hence , project and its part can not be copied and/or distributed without the express
 * permission of Keshav Bhatt <keshavnrj@gmail.com> .
 */

import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0
import Ubuntu.Components 1.1
import QtMultimedia 5.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import QtGraphicalEffects 1.0
import Ubuntu.Components.Popups 0.1
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
//for player tab floating  setting
import QtQuick.Layouts 1.0
import QtSystemInfo 5.0

MainView {


 //brand new filter shit,  copyright Keshav bhatt .  LoL :D
    function updateFilter()
    {
        var text = filterField.text
        var filter = "*"
        for(var i = 0; i<text.length; i++)
            if(!caseSensitiveCheckbox.checked)
                filter+= "[%1%2]".arg(text[i].toUpperCase()).arg(text[i].toLowerCase())
            else
                filter+= text[i]
        filter+="*"
       print(filter)
        folderModel.nameFilters = [filter]


if(filterField.length < 1){
filterback.running=true
}

    }

    Timer {
        id:filterback
        interval: 100; running:false ;
        onTriggered: {
 setnamefilter()

   }
}







//    applicationName sets the storage path
applicationName: "com.ubuntu.developer.keshavnrj.kMusicPlay"

id:mainWindow

//    headerColor: "#343C60"
//    backgroundColor: "#6A69A2"
//    footerColor: "#8896D5"
property bool activerec: false
property bool fullscreened: false

    // functions are called by respective buttons
           property string updateMeta: "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist="+player.metaData.albumArtist+"&song="+player.metaData.title
//property string onstt: "onState"
//property string offstt: "offState"
           property bool loading: infomodel.status===XmlListModel.Loading
           property int index: playlist.currentIndex
           property bool seekable: player.seekable
           property alias items: folderModel.count

function setnamefilter(){
     if(getSetting("loadvid")==0){
 folderModel.nameFilters = ["*.mp3" ,"*.webm" , "*.ogv" , "*.mp4" , "*.avi" , "*.wmv" , "*.mkv" , "*.flv" , "*.oga" , "*.ogg" , "*.flac" , " *.opus" , "*.m4a" , "*.aac" ]
        // playlist.update()
        }

     else if(getSetting("loadvid")==1)
     {folderModel.nameFilters = ["*.mp3" , "*.oga" , "*.ogg" , "*.flac" , " *.opus" , "*.m4a" , "*.aac" ]
   //  playlist.update()
     }
 }

//function to open db , save ,amd get data
// At the start of the application, we can initialize the tables we need if they haven't been created yet
function getDatabase() {

    // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
     return LocalStorage.openDatabaseSync("kMusicplay", "0.1", "kMusicPlay app Ubuntu", 10000);
}
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            var table  = tx.executeSql("SELECT * FROM settings");
            // Seed the table with default values
            if (table.rows.length===0) {
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["loadvid", 0]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["myLoadLastconditon", 0 ]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["volume", 0.5 ]);
            //  tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["myRepeatvalue", offstt ]);

                console.log('Loaded default Settings / table added');
            };
     });
}


// This function is used to write a setting into the database
function setSetting(setting, value) {
   // setting: string representing the setting name (eg: “username”)
   // value: string representing the value of the setting (eg: “myUsername”)
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
              //console.log(rs.rowsAffected)
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
  );
  // The function returns “OK” if it was successful, or “Error” if it wasn't
  return res;
}

   // This function is used to retrieve a setting from the database
   function getSetting(setting) {
      var db = getDatabase();
      var res="";
      db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
        if (rs.rows.length > 0) {
             res = rs.rows.item(0).value;
        } else {
            res = "Unknown";
        }
     })
     // The function returns “Unknown” if the setting was not found in the database
     // For more advanced projects, this should probably be handled through error codes
     return res
   }

//end function to get data and save data to db

//start song next previous playlist suffle function repeat code

function setIndex()
{
 //   console.log("setting index to: " + playlist.currentIndex /*+ "\n" + infomodel.source + " will loaded log from setIndex"*/);


    if ( playlist.currentIndex > items - 1   )
           {
                playlist.currentIndex = items - (items)

                player.source = folderModel.get(playlist.currentIndex, "fileURL");
                player.stop()
                console.log("playlist next "+  playlist.currentIndex+"."+items )
           }
    else if (   playlist.currentIndex < 0  )
           {
                playlist.currentIndex = playlist.currentIndex + (items )

                player.source = folderModel.get(playlist.currentIndex, "fileURL");
                console.log("playlist prev "+  playlist.currentIndex+"."+items )
           }
           else
               player.source = folderModel.get(playlist.currentIndex, "fileURL");
               playbanner.start();playbanner2.start();playbanner3.start();playbanner4.start();playbanner5.start();playbanner6.start();
               metaupdateTimer.running=true
       }

function getRandomArbitrary() {
    var randomnumber = Math.floor(Math.random() * (items - 0 + 1)) + 0;
    return randomnumber
}

     function next() {
index=playlist.currentIndex
         /*if(barLock.state == "onState"){setIndex(playlist.currentIndex ++ && player.play() )}
         else*/ if ( barLock.state == "onState" && player.status===MediaPlayer.EndOfMedia ){setIndex(playlist.currentIndex && player.play() )}
         else if (shuffle.state == "onState"){playlist.currentIndex = getRandomArbitrary()  ; setIndex(playlist.currentIndex  && player.play()) ; /*console.log(getRandomArbitrary())*/ }
         else setIndex(playlist.currentIndex ++ );

          root.title ="kMusicPlay : " + folderModel.get(playlist.currentIndex,"fileName");
          playertab.title ="kMusicPlay : " + folderModel.get(playlist.currentIndex,"fileName");

           playbanner.start();playbanner2.start();playbanner3.start();playbanner4.start();playbanner5.start();playbanner6.start();
      metaupdateTimer.running=true }

     function previous() {
         index=playlist.currentIndex
        // if(barLock.state == "onState"){setIndex(playlist.currentIndex && player.play() )}
         if ( barLock.state == "onState" && player.status===MediaPlayer.EndOfMedia ){setIndex(playlist.currentIndex && player.play() )}
         else if (shuffle.state == "onState"){playlist.currentIndex = getRandomArbitrary()  ; setIndex(playlist.currentIndex  && player.play()) ; /*console.log(getRandomArbitrary())*/ }
         else setIndex(playlist.currentIndex -- );

         root.title ="kMusicPlay : " + folderModel.get(index,"fileName");
         playertab.title ="kMusicPlay : " + folderModel.get(index,"fileName");

        playbanner.start();playbanner2.start();playbanner3.start();playbanner4.start();playbanner5.start();playbanner6.start();
       metaupdateTimer.running=true
     }

  //End song next previous playlist suffle repeat function code
             focus:true
             Keys.onPressed: { enabled:false;
                 if(event.key===Qt.Key_Control)
                     filterField.focus=false
                  else if (event.key===Qt.Key_P && filterField.focus===false && (tabholder.selectedTabIndex === 0 ||tabholder.selectedTabIndex === 1 ) )
                        player.playPause()
                 else if ((event.key===Qt.Key_S) && (event.modifiers & Qt.ControlModifier))
                        player.stop()
                 else if ((event.key===Qt.Key_Right) && (event.modifiers & Qt.ControlModifier))
                        next()
                 else if ((event.key===Qt.Key_Left) && (event.modifiers & Qt.ControlModifier))
                        previous()
                 else if ((event.key===Qt.Key_Q) && (event.modifiers & Qt.ControlModifier)){
                        filterField.focus=false
                        PopupUtils.open(dialog, null)}




                 else if (event.key===Qt.Key_Right && filterField.focus===false)
                   player.seek(player.position + 2000)
                 else if (event.key===Qt.Key_Left && filterField.focus===false)
                     player.seek(player.position - 2000)
                 else if (event.key===Qt.Key_Up && filterField.focus===false)
//                     player.volume=player.volume + 0.1
                      player.volumeUp()
                 else if (event.key===Qt.Key_Down && filterField.focus===false)
//                     player.volume=player.volume - 0.1
                      player.volumeDown()


                    else if ((event.key===Qt.Key_O) && (event.modifiers & Qt.ControlModifier))
                 fileDialogAideo.open()
                        }



    width: units.gu(62.5)
    height: units.gu(75)
    Tabs{
        id:tabholder

        Tab{ title: i18n.tr("Library")

    page:Page {
    id: root
    title:i18n.tr("kMusicplay:"+player.metaData.title)
    anchors.fill:parent
    anchors.topMargin:0



    Image {
        id: bgr
        fillMode: Image.PreserveAspectCrop
        source: "bgr2.png"
        anchors.fill: parent
opacity: 0.1
    }

    /*start Audio chooser file dialog window */
        FileDialog {

            id: fileDialogAideo
            title: "Choose a folder with Music"
            selectFolder: true
            selectMultiple: true
            onAccepted: {folderModel.folder = fileUrl + "/"
                console.log(getSetting("myLoadLastconditon"))
                if(getSetting("myLoadLastconditon")==0){
                    setSetting("mySetting", folderModel.folder);
                console.log("Saved to load in next session " + folderModel.folder)}

                else if(getSetting("myLoadLastconditon")==1)
                {setSetting("mySetting", "")}
            }
          }
    /*end audio chooser file dialog window */

SideBar{
    id:sidesetting
    z:  activerec2 ? 10000 : 1000
    onVisibleChanged: console.log(activerec2)
   // activerec: true
}



// Start playlist
    ListView {
        anchors.fill: parent
        z:1000
        width: parent.width-sidesetting.width
        anchors.leftMargin: (parent.width+8) - (sidesetting.width)
        anchors.top:parent.top
        anchors.bottomMargin: (searchRow.height+playactrl.height+playaseeker.height+playerswitch.height)
        anchors.bottom: searchRow.top ;
     //   height: parent.height - (searchRow.height+playactrl.height+/*playctrl2.height+*/ playaseeker.height + playerswitch.height)
        objectName: "playlistt"
        id:playlist
        clip:true
        highlightFollowsCurrentItem: true

onWidthChanged: {
console.log(sidesetting.z)
console.log( "playlist"+playlist.z)
}



    // start  scrollbars list
     Scrollbar{flickableItem: playlist }
 //    end  scrollbars list

        //start adding item to playlist trasition
        add: Transition {id:damn
               NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
               NumberAnimation { property: "scale"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 750 }
           }

           addDisplaced: Transition {
               NumberAnimation { properties: "y"; duration: 600; easing.type: Easing.InBack }
           }

           remove: Transition {
               NumberAnimation { property: "scale"; from: 1.0; to: 0; duration: 200 }
               NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 200 }
           }

           removeDisplaced: Transition {
               NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.OutBack }
           }

        //end adding item to playlist trasition

   // start listmodel from floderlistmodel
       model: FolderListModel{id: folderModel

            objectName: "folderModel"
            showDirs: false
            showOnlyReadable:true
            onFolderChanged: {playlist.update();
            vidmode.checked=false
            }
            Component.onCompleted:   playlist.update()
            }
    // end listmodel from floderlistmodel


        delegate:   ListItem.Subtitled {
        id: playa
        property int listY: y - playlist.contentY
                property real angleZ: (40 * listY)  / playlist.height        // 0 - 90 degrees
                transform: Rotation { origin.x: width / 2; origin.y: 50; axis { x: 1; y: 0; z: 0 } angle: angleZ}
                 Binding {
                            target: playa
                            property: "angleZ"
                            value: 0
                            when: !(playlist.moving || playlist.dragging)
                        }

                        Behavior on angleZ {
                            NumberAnimation {duration: 150; to: 0}
                            enabled: !(playlist.flicking || playlist.dragging)
                        }



        //removal of item from list with sliding shit
//        removable: true
//        backgroundIndicator: Rectangle
//        {
//            anchors.fill: parent
//            color: Theme.palette.normal.base
//            Text { anchors.centerIn: parent
//                color: "grey"
//                id: confirm
//                text: qsTr("Slide Remove From Playlist ")
//                 }

//         }
        //end removal of item from list with sliding shit
        width: parent.width
        height:40
        iconSource: "music.png"
        text: fileName


//  subText:player.metaData.title + "   " + durationLabel.text +" / "+ positionLabel.text + "   - Now Playing" now it will show subText only for currently playing item
        subText: ""
        MouseArea{anchors.fill: parent;  drag.target:parent; drag.axis: Drag.XAxis
        onClicked:{ playlist.currentIndex=index;
                    player.source=folderModel.get(index, "fileURL");

                    root.title ="kMusicPlay : " + fileName;
                    playertab.title ="kMusicPlay : " + folderModel.get(index,"fileName");

                    player.playbackState === MediaPlayer.PlayingState ?  playa.state = "current" : playa.state = "not";
 metaupdateTimer.running=true
        }
                          }


     Binding { target: playa; property: "iconSource"; value:Qt.resolvedUrl("playing.png"); when: player.source===folderModel.get(index, "fileURL") || player.StoppedState ? true  : false ||player.status===MediaPlayer.EndOfMedia }

     Binding { target: playa; property: "subText"; value:player.metaData.title + "   " + durationLabel.text +" / "+ positionLabel.text; when: player.source===folderModel.get(index, "fileURL")}
     Binding { target: playa; property: "subText"; value:"" ; when: player.source!==folderModel.get(index, "fileURL")}



                            states: [
                                       State {
                                           name: "current"
                                            when: playlist.isCurrentItem  || player.playbackState.isPlaying || player.source===folderModel.get(index, "fileURL" || player.status===MediaPlayer.EndOfMedia )
                                           PropertyChanges { target:playa ; iconSource:"playing.png" ;opacity:0.9  ; height : 45; }
                                       },
                                       State {
                                           name: "not"
                                           when: !playlist.isCurrentItem || !player.playbackState.isPlaying
                                           PropertyChanges { target:playa ; iconSource:"music.png" ; height: 43 }
                                       }]
                               state:"not"




                        }

        //start highlight playing listitem
                highlight: Rectangle {
                    id:highlighter
                    anchors.fill: playlist.currentItem
                    opacity: 0.5
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.02;
                                    color: "#eeeeee";
                                }
                                GradientStop {
                                    position: 1.00;
                                    color: "#cccaca";
                                }
                            }

                        }
        //end highlight playing listitem

}
// End playlist





/*start  Audio controllbar inside library */

        //start   playercontrol top ShaderEffect
         Row{id:playerswitch; width: parent.width ; height:3 ;  anchors.bottom:searchRow.top ;
Rectangle{ width:parent.width ;height: parent.height ; color:"#C2C2C1"; z: 1000
    gradient: Gradient {
        GradientStop {
            position: 0.07;
            color: "#ececed";
        }
        GradientStop {
            position: 1.00;
            color: "#c2c2c1";
        }
    }


    }


         }

        Rectangle{id:searchRow
            z:1001
            anchors.bottom:playactrl.top ;
            color:"#C2C2C1"
             width:parent.width ; height:30  ;



//             Label{

//                 id:filtrrr
//                 text:"Filter"
//                 anchors.verticalCenter: parent.verticalCenter
//             }


             TextField
             {
                 id: filterField
                 height: 25
                 width: parent.width  - 20
                 anchors.verticalCenter: parent.verticalCenter
                 anchors.horizontalCenter: parent.horizontalCenter
                 placeholderText : "Search"
                 opacity: 0.4
                 onTextChanged: {
                   updateFilter()
                 }
//                 MouseArea {
//                     anchors.fill: parent
//                     onClicked:filterField.forceActiveFocus();
//                 }

             }
//            Label{
//              id:btncls
//              anchors.verticalCenter: parent.verticalCenter
//              text:"Close"
//              height: parent.height
//              MouseArea{anchors.fill: parent
//              onClicked:{}
//              }

//             }

//             Label {
//                 id:caseSence
//                 text:"Case Sensitive"
//             anchors.verticalCenter: parent.verticalCenter
//             }
             CheckBox
             {   visible: false
                 id: caseSensitiveCheckbox
                 anchors.verticalCenter: parent.verticalCenter
                 checked: false
                 onCheckedChanged:updateFilter()
             }

         }
         //end playercontrol top ShaderEffect




        Row{id:playactrl; width: parent.width ; height:50 ; z: 1000 ; anchors.bottom: playaseeker.top ;

Rectangle{id:playactrl2; width:parent.width ;height: parent.height; color:"#C2C2C1"; /*color: UbuntuColors.coolGrey;*/

    //text:"Open"
        Icon {x:24 ;anchors.verticalCenter: parent.verticalCenter;width:24;height: 24;name: "navigation-menu"
            scale: mouseAreaO.pressed && mouseAreaO.containsMouse ? 0.7 : 1.0
            opacity: mouseAreaO.pressed && mouseAreaO.containsMouse ? 0.5 : 1.0
            Behavior on scale {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
        MouseArea{id:mouseAreaO;anchors.fill: parent;onClicked:{ fileDialogAideo.open() ;playlist.visible=true ; } }}
        //text:"Play"
        Icon {x:72 ;anchors.verticalCenter: parent.verticalCenter;width:24;height: 24;name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
            scale: mouseArea1.pressed && mouseArea1.containsMouse ? 0.7 : 1.0
            opacity: mouseArea1.pressed && mouseArea1.containsMouse ? 0.5 : 1.0
            Behavior on scale {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
        MouseArea{id:mouseArea1;anchors.fill: parent;onClicked:{ player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play() }}}
        //text:"Pause"
      Icon {id:prevButton;x:120 ;anchors.verticalCenter: parent.verticalCenter;width:24;height: 24;name: "media-skip-backward"
          scale: mouseArea2.pressed && mouseArea2.containsMouse ? 0.7 : 1.0
          opacity: mouseArea2.pressed && mouseArea2.containsMouse ? 0.5 : 1.0
          Behavior on scale {
              NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
          }
          Behavior on opacity {
              NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
          }
          MouseArea{id:mouseArea2;anchors.fill: parent;onClicked:previous(); }}
        //text:"Stop"
        Icon {id:nextButton;x:168 ;anchors.verticalCenter: parent.verticalCenter;width:24;height: 24;name: "media-skip-forward"
            scale: mouseArea3.pressed && mouseArea3.containsMouse ? 0.7 : 1.0
            opacity: mouseArea3.pressed && mouseArea3.containsMouse ? 0.5 : 1.0

            Behavior on scale {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
            MouseArea{id:mouseArea3;anchors.fill: parent;onClicked:next(); }}
        //text:"volume"
        Icon { id:volu; x:216 ;anchors.verticalCenter: parent.verticalCenter;width:24;height: 24; name: "speaker"
//mousearea over volume icon to change volume with scrolling and mute when clicked
        MouseArea{anchors.fill: parent
        onWheel:  {
                            if (wheel.angleDelta.y < 0)
                            liveSliderr.value=liveSliderr.value-0.1;

                            else
                            liveSliderr.value=liveSliderr.value+0.1;


        }
        onClicked:liveSliderr.value = 0.0

        }


        }
        //text:"seeker"
   //     Icon { id:currentPosition ;  x:380 ;anchors.verticalCenter: parent.verticalCenter;width:24;height: 24; name: "location"}
        Label {
            id: positionLabel
            anchors.verticalCenter: parent.verticalCenter
            fontSize: "large"
            x: 390
            readonly property int minutes: Math.floor(player.position / 60000)
            readonly property int seconds: Math.round((player.position % 60000) / 1000)
            text: Qt.formatTime(new Date(0, 0, 0, 0, minutes, seconds), qsTr("mm:ss"))
                }
        //start palyer switchbutton
        Icon{id:lollla;anchors.verticalCenter: parent.verticalCenter; width:20;height: 20;name: "go-next" ; x:458
            scale: mouseAre.pressed && mouseAre.containsMouse ? 0.7 : 1.0
            opacity: mouseAre.pressed && mouseAre.containsMouse ? 0.5 : 1.0
            Behavior on scale {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
            }
            MouseArea{id:mouseAre;anchors.fill: parent
            onClicked: {tabholder.selectedTabIndex = 1}}}
         //End palyer switchbutton

//volume sseeker
                  DNASlider {
                      function formatValue(v) { return v.toFixed(2) }
                      id: liveSliderr
                      anchors.verticalCenter: parent.verticalCenter
                      x:255
                        height:parent.height
                      width: 120
                      opacity: 0.8
                      value:getSetting("volume")

                      updateValueWhileDragging: true

                       minimumValue: 0.0
                       maximumValue: 1.0

//                       MouseArea {
//                           onWheel: {
//                               if (wheel.modifiers & Qt.ControlModifier) {
//                                   if (wheel.angleDelta.y > 0)
//                                       zoomIn();
//                                   else
//                                       zoomOut();
//                               }
//                           }
//                       }

//added timer to reduce cpu load , this will make DB transaction after 2 sec of liveslider value change
                       Timer {
                           id:volumeWriter  //writes player.volume to database to load volume at next session
                           interval: 2000; running: false
                           onTriggered:{  setSetting("volume", liveSliderr.value)

                           }
                      }
//added timer to reduce cpu load , this will make DB transaction after 2 sec of liveslider value change


                       onValueChanged: {

                            volumeWriter.restart()


                        if (liveSliderr.value <= 0 ){volu.name="speaker-mute"}
                                            else{volu.name="speaker"}


                }

            }
//end volume slider
        }


        }
Row{id:playaseeker; width: parent.width ; height:45; z: 1000 ; anchors.bottom: parent.bottom ;
// Start audio Seeker
   Rectangle { width:parent.width ; height: parent.height  ;  color:"#C2C2C1"; /*color: UbuntuColors.coolGrey;*/

                                       DNASlider {
                                               id: liveseeker
                                               anchors.verticalCenter: parent.verticalCenter
                                               opacity: 0.8
                                               anchors.fill: parent
                                               updateValueWhileDragging: true
                                               width: parent.width
                                               maximumValue: player.duration
                                               value:player.position
                                               property bool sync: false
                                               onValueChanged: {
                                                   if (!sync)
                                                       player.seek(value)
                                                                }

                                               Connections {
                                                   target: player
                                                   onPositionChanged: {
                                                      liveseeker.sync = true
                                                       liveseeker.value = player.position

                                                       liveseeker.sync = false
                                                                       }
                                                           }

                    //to return the position from liveseeker
                               readonly property int minutes: Math.floor(liveseeker.value / 60000)
                               readonly property int seconds: Math.round((liveseeker.value % 60000) / 1000)
                               function formatValue(v) { return (Qt.formatTime(new Date(0, 0, 0, 0, minutes, seconds), qsTr("mm:ss")))   }



                           Label {
                               visible: false
                               id: durationLabel

                               readonly property int minutes: Math.floor(player.duration / 60000)
                               readonly property int seconds: Math.round((player.duration % 60000) / 1000)
                               text: Qt.formatTime(new Date(0, 0, 0, 0, minutes, seconds), qsTr("mm:ss"))
                                    }
                                           }


        }
//end Audio Seeker

   }
/*end  Audio controllbar inside library */

MouseArea {
    anchors.fill: parent
    onClicked:filterField.focus=false
}

         }

            }




//start player tab
    FontLoader { id: myFont; source: "AndroidClock.ttf" }
    FontLoader { id: myFont4meta; source: "Steinerlight.ttf" }

            Tab{ id:playertabb; title: i18n.tr("Player "+player.errorString)
            page:Page{
                id:playertab;
                title:i18n.tr("kMusicplay:" + folderModel.get(playlist.currentIndex,"fileName"));

//setting rectangle inside palyer tab
                Rectangle{id:settingRec;
                    width: parent.width;
                 //   height: activerec ? 100 : 0
                 //   opacity: activerec ? 0 : 1
                    color:"#81C4DF" ;
                    RectangularGlow {

                        anchors.fill: parent
                        glowRadius: 4
                        spread: 0.1
                        color: "#81C4DF"
                        cornerRadius: parent.radius + glowRadius}

                    Image {
                        id: damnjpeg
                        source: "damn.jpeg"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0.1

                    }
//Behavior on height {NumberAnimation {duration: 800; easing.type: Easing.OutQuad}}
//Behavior on y {NumberAnimation {duration: 800; easing.type: Easing.OutQuad}}

//TextField{
//        id: searchField
//        width: parent.width
//        visible: true

//        onTextChanged: {
////                timer.restart();
//            if(text.length > 0 ) {
//                applyFilter();
//            } else {
//                 setnamefilter();
//            }
//        }
//}
RowLayout{
    anchors.centerIn: parent

    Text {font.family: myFont.name

        font.pointSize: 12
        opacity: 0.6

        text:"Repeat"  }
    DNASwitch{
    id:barLock
}
////state:getSetting("myRepeatvalue")
//    onStateChanged :{
//        if(barLock.state=="onState"){
//           setSetting("myRepeatvalue", onstt );
//        // console.log("statechanged  " + getSetting("myRepeatvalue")+" " + barLock.state)
//   }
//        else  if(barLock.state=="offState") {
//             setSetting("myRepeatvalue", offstt );
//           //  console.log("statechanged  " + getSetting("myRepeatvalue")+" " + barLock.state)
//}
//        }
//Component.onCompleted:   barLock.state=getSetting("myRepeatvalue")

//    }

    Text {font.family: myFont.name

        opacity: 0.6
        font.pointSize: 12

        text:"Shuffle"  }
    DNASwitch{
    id:shuffle
    }

//    Text {font.family: myFont.name

//        opacity: 0.6
//        font.pointSize: 12

//        text:"Rep.List"  }
//    DNASwitch{
//    id:repLst
//    }


    Text {font.family: myFont.name

        opacity:  player.hasVideo ? 0.6 : 0.4

        font.pointSize: 12

        text:"Video mode"  }


DNACheckBox{
id:vidmode
   enabled:  player.hasVideo ? true : false

onCheckedChanged:  {


    if(checked === true && fullscreened===true ) { mainWindow.header.hide() ; mainWindow.header.visible = false }
    if (checked === true && player.hasVideo){ ScreenSaver.screenSaverEnabled=false ;  vidout.source=player; player.stop();player.play();   }
    else if (checked === false) {vidout.enabled=false ;  /*vidout.destroy()*/ mainWindow.header.show() ; mainWindow.header.visible=true

    }

    vidout.source=player; player.stop();player.play();

    activerec = !activerec;


    settingRec.z = activerec ? 10000 : 1000 ;

    settingRecEvo.y  = activerec ? 100 : 2;

    settingRec.height = activerec ? settingRec.height : 0;
//console.log(vidmode.checked)
        }
     }
    }

   }
//setting rectangle inside palyer tab

//setting rectangle evoker

                Rectangle{id:settingRecEvo;width: parent.width ; height:10 ; /*color:"#C1C2C2"*/ color:"transparent" ;   anchors.horizontalCenter: parent.horizontalCenter;

                    z: vidmode.checked ? 10000 : 1000
                    radius: 1;
                    y:2
                    opacity: 0.7
                    Image {id:damnbrkr
                        width: parent.width; height: 10
                        fillMode: Image.TileHorizontally
                        verticalAlignment: Image.AlignLeft
                        source: "breaker.png"
//                        Glow {
//                               anchors.fill:  damnbrkr
//                               radius:4
//                               samples: 22
//                               color: "skyblue"
//                               source: damnbrkr
//                           }
                    }



                    MouseArea{id:evoRecmouse; anchors.fill: parent;
                    onClicked:{

                        activerec = !activerec;


                        settingRec.z = activerec ? 10000 : 1000 ;

                        settingRecEvo.y  = activerec ? 100 : 2;


                     }

                    }

                    PropertyAnimation {
                        running: activerec ? true : false
                        id: animationShow
                        easing.type: Easing.OutQuint
                        duration: 900
                        target: settingRec
                        property: "height"
                        to: 100
                        from: 0
                    }
                    PropertyAnimation {
                        running: activerec ? false : true
                        id: animationShowrte
                        easing.type: Easing.OutQuint
                        duration: 900
                        target: settingRec
                        property: "height"
                        to: 0
                        from: 100
                    }
                    PropertyAnimation {
                        running: activerec ? true : false
                        id: animationShow2
                        easing.type: Easing.Linear
                        duration: 400
                        target: settingRec
                        property: "opacity"
                        to: 1
                        from: 0
                    }
                    PropertyAnimation {
                        running: activerec ? false : true
                        id: animationShow24
                        easing.type: Easing.Linear
                        duration: 400
                        target: settingRec
                        property: "opacity"
                        to: 0
                        from: 1
                    }


                    Behavior on y {NumberAnimation {duration: 800; easing.type: Easing.OutQuad}}

                    scale: evoRecmouse.pressed && evoRecmouse.containsMouse ? 0.7 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
                    }

 }
//end setting rectangle evoker


                //start video mode
                                Rectangle{  id:vidoutWrap; z:1001;anchors.centerIn: parent; width:parent.width/2 ; height:parent.height/3;color:"transparent"
                                     visible: vidmode.checked ? true : false

                                    onWidthChanged: {if(vidoutWrap.width === playertab.width){
                                            nametttt.text="Exit FullScreen";
                                            mainWindow.header.hide()
                                            mainWindow.header.visible=false


                                        }
                                        else if (vidoutWrap.width === vidout.width  || vidoutWrap.height=== playertab.height/3 /*|| vidoutWrap.height != playertab.height */){
                                            nametttt.text="FullScreen";
                                            mainWindow.header.show()
                                            mainWindow.header.visible=true
                                        }
                                      //  else if (vidoutWrap.width!==playertab.width ||  vidout.width ){nametttt.text="Player Reset";  }

                                    }
                                    RectangularGlow {
                                          id: effect2
                                          anchors.fill: vidoutWrap
                                          glowRadius: 12
                                          spread:0.4
                                          color: "black"
                                          cornerRadius: vidoutWrap.radius + glowRadius

                                      }

                                   // y:parent.height-progressBar.height - 10
                                VideoOutput{
                                 id:vidout
                                 enabled: vidmode.checked ? true : false
                                 anchors.fill: parent
                                 fillMode:VideoOutput.PreserveAspectFit
                                 z:1002

                                }
                                Timer {
                                    id:fullscrHiderTimer
                                    interval: 5000; running: fullscr.visible ? true :false
                                    onTriggered:{ animationShowV4.start()

                                    }
                               }
                                Rectangle{
                                    color:"black";
                                    anchors.fill:vidout ;
                                    id:fullscr

                                    opacity: fullscr.visible ?  0.5 : 0.0

                                     Behavior on opacity {
                                         NumberAnimation { duration:1200; easing.type: Easing.OutQuad}
                                         }
                                    PropertyAnimation {
                                       //running: vidmode.checked ? "true":"false";
                                        id: animationShowV4
                                        easing.type:Easing.Linear
                                        duration: 1000
                                        target: fullscr; property: "opacity"; to: 0 ; from: 0.5
                                    }
                                                PropertyAnimation {
                                                   //running: vidmode.checked ? "true":"false";
                                                    id: animationShowV4_1
                                                    easing.type:Easing.Linear
                                                    duration: 1000
                                                    target: fullscr; property: "opacity"; to: 0.5 ; from: 0
                                                }

//                                    visible: vidmode.checked ? true : false
                                   visible: false

                                    Text{id:nowVolu2;color: "skyblue"; text: player.volume * 100 ;
                                        font.family: myFont.name;
                                       // style: Text.Raised;
                                       font.pointSize: fullscreened ? 17 : 14 ;

                                         y:parent.height / 3
                                      //  anchors.bottomMargin:  30
                                       // anchors.bottom: playpausein.top

                                        Behavior on opacity {
                                        NumberAnimation { duration: 450; easing.type: Easing.OutQuad }
                                        }
                                        anchors.horizontalCenter: parent.horizontalCenter

                                    }

                                    //start play pause button

                                                    Image{id:playpausein;z:1001;
                                                        anchors.centerIn: parent
                                                        width:parent.width  / 8.5  ;fillMode: Image.PreserveAspectFit;
                                                        source: player.playbackState === MediaPlayer.PlayingState ? "pause.png" : "play.png"

                                                      //  anchors.topMargin:  30

                                                        scale: mouseAreappp.pressed && mouseAreappp.containsMouse ? 0.7 : 1.0
                                                       opacity: mouseAreaNN.pressed && mouseAreaNN.containsMouse ? 0.1 : 0.3
                                                       Behavior on scale {
                                                           NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                                       }
                                                       Behavior on opacity {
                                                           NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                                       }


                                                        enabled: player.hasAudio
                                                                MouseArea{anchors.fill: parent ; id:mouseAreappp
                                                                onClicked: {player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
                                                                    if( fullscrHiderTimer.running===false )
                                                                    { fullscr.z=1003; animationShowV4_1.start() ; fullscr.visible=true ;   fullscrHiderTimer.restart();}

                                                                }

                                                                }
                                                              }

                                    //End play pause button
                                                    Text {
                                                        color: "white"
                                                       // anchors.bottom: playpausein.bottom

                                                        y:parent.height / 1.5
                                                        anchors.horizontalCenter: parent.horizontalCenter;
                                                        id: nametttt
                                                        text: qsTr("FullScreen")
                                                        visible:  vidmode.checked ? true : false
                                                        font.family: myFont4meta.name;
                                                        font.pointSize: fullscreened ? 14 : 10 ;

                                                       scale: fullscrner.pressed  ?  0.5 : 1.0
                                                       Behavior on scale {
                                                           NumberAnimation { duration:150; easing.type: Easing.Linear}
                                                       }

                                                    }
                                    //start Next button
                                        Image{id:overnextt; anchors.right: parent.right;source:overnext.source; height:parent.height ; width:parent.width  / 9.5 ;fillMode: Image.PreserveAspectFit;
                                            scale: mouseAreaNN.pressed && mouseAreaNN.containsMouse ? 0.7 : 1.0
                                            opacity: mouseAreaNN.pressed && mouseAreaNN.containsMouse ? 0.1 : 0.3
                                            Behavior on scale {
                                                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                            }
                                            Behavior on opacity {
                                                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                            }
                                            MouseArea{anchors.fill: parent; id:mouseAreaNN;
                                                onClicked: {next();
                                                    if( fullscrHiderTimer.running===false )
                                                    { fullscr.z=1003; animationShowV4_1.start() ; fullscr.visible=true ;   fullscrHiderTimer.restart();}
                                                }

                                            }
                                        }

                                    //End Next button
                                        //start Previous button
                                                        Image{id:overprevv;anchors.left: parent.left;source:overprev.source; height:parent.height ; width:parent.width / 9.5 ; fillMode: Image.PreserveAspectFit;
                                                            scale: mouseAreaPP.pressed && mouseAreaPP.containsMouse ? 0.7 : 1.0
                                                            opacity: mouseAreaPP.pressed && mouseAreaPP.containsMouse ? 0.1 : 0.3
                                                            Behavior on scale {
                                                                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                                            }
                                                            Behavior on opacity {
                                                                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                                            }
                                                            MouseArea{anchors.fill: parent;id:mouseAreaPP;
                                                                onClicked: {previous();
                                                                    if( fullscrHiderTimer.running===false )
                                                                    { fullscr.z=1003; animationShowV4_1.start() ; fullscr.visible=true ;   fullscrHiderTimer.restart();}
                                                                }

                                                            }
                                                        }
                                        //End Previous button


                            }

onVisibleChanged: fullscrHiderTimer.start()
                                MouseArea{anchors.fill: parent
                                    id:fullscrner
                                    hoverEnabled: true


onMouseXChanged: {

    if( fullscrHiderTimer.running===false )
    { fullscr.z=1003; animationShowV4_1.start() ; fullscr.visible=true ;   fullscrHiderTimer.restart();}
  }
                                onEntered:{ if(player.hasVideo) fullscr.visible=true; /*fullscr.focus=true ;*/fullscr.z=1003;

                                    if(vidoutWrap.width===playertab.width){nametttt.text="Exit FullScreen";vidoutWrap.color="black";/*fullscreened = true*/}
                                    else if (/*vidoutWrap.width=== vidout.width  ||*/vidoutWrap.height===playertab.height/3){nametttt.text="FullScreen";vidoutWrap.color= "transparent"; /*fullscreened = false*/}
                                 //   else if (vidoutWrap.width!==playertab.width ||  vidout.width ){nametttt.text="Player Reset"; vidoutWrap.color="transparent"; fullscreened = false}



                                }
                                onExited:{  fullscr.visible = false; fullscr.z = 0;
                                }
                                onClicked: {//console.log("fullscreen clicked");
                                       if(  nametttt.text==="FullScreen"){

                                        vidoutWrap.color="black";
                                        vidoutWrap.width=playertab.width;
                                        vidoutWrap.height = playertab.height
                                        animationShowV.running = true ; animationShowVH.running=true
                                        fullscreened = true
//


                                      }

                                    else if (nametttt.text==="Exit FullScreen"){

                                        vidoutWrap.color="transparent";
                                        vidoutWrap.width=playertab.width/2 ;
                                        vidoutWrap.height=parent.height/3;
                                        animationShowV_1.running=true;animationShowVH_1.running=true
                                        fullscreened = false
//

                                    }
                                    else if (nametttt.text==="Player Reset"){vidoutWrap.width= vidout.width ; vidoutWrap.height=playertab.height/3;vidoutWrap.color="transparent" ; animationShowV_1.running=true}
                                }

                                onWheel: { if( fullscrHiderTimer.running===false )
                                    { fullscr.z=1003; animationShowV4_1.start() ; fullscr.visible=true ;   fullscrHiderTimer.restart();}

                                    if (wheel.angleDelta.y < 0)
                                    liveSliderr.value=liveSliderr.value-0.09;

                                    else
                                    liveSliderr.value=liveSliderr.value+0.09;

                                        }

                                }


                                }


                                PropertyAnimation {
    //when fullscreen text
                                    id: animationShowV
                                    easing.type:Easing.OutCirc
                                    duration: 1100
                                    target: vidoutWrap; property: "width"; to: playertab.width ; from: vidoutWrap.width / 1.5
                                }
                                PropertyAnimation {
    //when exit fullscreen text
                                    id: animationShowV_1
                                    easing.type:Easing.InOutBack
                                    duration: 1100
                                    target: vidoutWrap; property: "width"; to: vidout.width   ; from: playertab.width
                                }




                                PropertyAnimation {
    //when fullscreen text
                                    id: animationShowVH
                                    easing.type:Easing.OutInBack
                                    duration: 1100
                                    target: vidoutWrap; property: "height"; to:  playertab.height + mainWindow.header.height ; from: vidout.height / 1.5
                                }
                                PropertyAnimation {
    //when exit fullscreen text
                                    id: animationShowVH_1
                                    easing.type:Easing.InOutBack
                                    duration: 1100
                                    target: vidoutWrap; property: "height";  to:  vidoutWrap.height   ; from:playertab.height + mainWindow.header.height /1.5
                                }



                                PropertyAnimation {
                                   running: vidmode.checked ? "true":"false";
                                    id: animationShowV2
                                    easing.type:Easing.Linear
                                    duration: 700
                                    target: vidoutWrap; property: "opacity"; to: 1 ; from:0
                                }


                //end video mode




//start control Overlay rectangle
                Rectangle{width:parent.width;
                    id:overlayControls;
                    anchors.centerIn: parent;
                    anchors.verticalCenter: parent.verticalCenter;
                    color:"#000000";
                    height:parent.height / 5;
                    z:1000
                    opacity: 0.7
                    BorderImage {
                        id: nameborder
                        source: "divider.png"
                        width: parent.width;
                        height: parent.height;
                          border.top: 1
                          border.bottom: 1
                    }

//start Previous button
                Image{id:overprev;z:1001;anchors.left: parent.left;source:"prev.png"; height:parent.height ; width:parent.width / 5.5 ; fillMode: Image.PreserveAspectFit;
                    scale: mouseAreaP.pressed && mouseAreaP.containsMouse ? 0.7 : 1.0
                    opacity: mouseAreaP.pressed && mouseAreaP.containsMouse ? 0.5 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
                    }
                    MouseArea{anchors.fill: parent;id:mouseAreaP;onClicked: {previous();
//                            console.log("Previous pressed,"+" Now playing" + folderModel.get(index , "fileURL"))

                        }}}
//End Previous button
//start play pause button

                Image{id:playpause;z:1001;anchors.horizontalCenter: parent.horizontalCenter;height:parent.height ; width:parent.width/ 5.5;fillMode: Image.PreserveAspectFit;source: player.playbackState === MediaPlayer.PlayingState ? "pause.png" : "play.png"


                    scale: mouseAreapp.pressed && mouseAreapp.containsMouse ? 0.7 : 1.0
                    opacity: mouseAreapp.pressed && mouseAreapp.containsMouse ? 0.5 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
                    }


                    enabled: player.hasAudio
                            MouseArea{anchors.fill: parent ; id:mouseAreapp
                            onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()}
                }

                Clock{
                    id:volumeer
                    anchors.centerIn: playpause
                    opacity: overlayControlsMA.containsMouse ? 0.8 : 0.0
                    Behavior on opacity {
                    NumberAnimation { duration: 450; easing.type: Easing.OutQuad }
                    }

                }



//End play pause button

//start Next button
    Image{id:overnext; z:1001;anchors.right: parent.right;source:"next.png"; height:parent.height ; width:parent.width  / 5.5 ;fillMode: Image.PreserveAspectFit;
        scale: mouseAreaN.pressed && mouseAreaN.containsMouse ? 0.7 : 1.0
        opacity: mouseAreaN.pressed && mouseAreaN.containsMouse ? 0.5 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
        }
        Behavior on opacity {
            NumberAnimation { duration: 350; easing.type: Easing.OutQuad }
        }
        MouseArea{anchors.fill: parent; id:mouseAreaN;onClicked: {next();
//                console.log("Next pressed"+" Now playing" + folderModel.get(index , "fileURL"))
            }

        }
    }

//End Next button
    MouseArea{
        id:overlayControlsMA
        anchors.fill: parent
        hoverEnabled: true
    onWheel:  {
                        if (wheel.angleDelta.y < 0)
                        liveSliderr.value=liveSliderr.value-0.09;

                        else
                        liveSliderr.value=liveSliderr.value+0.09;


    }
                }
                }
//End controls Overlay rectangle

            Rectangle{
            id:playerView;
            anchors.fill: parent ;
            visible: true
            color:"#000000"
            MouseArea{anchors.fill: parent;
            onClicked: {overlayControls.visible= true;}}
//Start Page Background Image ,,, Need hard work : must changed with plaing song albumart
            Image {
                id: coverArt
                source: "bg.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                opacity: 0.2
                MouseArea{anchors.fill: parent
                    onWheel:  {
                                        if (wheel.angleDelta.y < 0)
                                        liveseeker.value=liveseeker.value-6000;

                                        else
                                        liveseeker.value=liveseeker.value+6000;

                    }
                }

                }
//End Page Background Image ,,, Need hard work : must changed with plaing song albumart

//Start Currentplaying information ,,, Need hard work too
            Column{
                id:infocolumn
Row{ Text { text:"."+ "\n"}}
Item{id:mp3info ; /*height:parent.height/4*/  width:root.width ; y:30

    Image {
        id: navb
        anchors.left: parent.left
        source: "navb.png"
        scale: backnavM.pressed && backnavM.containsMouse ? 0.7 : 1.0
        opacity: backnavM.pressed && backnavM.containsMouse ? 0.2 : 0.5
        Behavior on scale {
            NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
        }
        Behavior on opacity {
            NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
        }
        MouseArea{ id:backnavM;anchors.fill: parent ;onClicked: tabholder.selectedTabIndex = 0}
    }

    Text{id:nowTimer;color: "skyblue"; text:positionLabel.text + " - " + durationLabel.text ; font.family: myFont.name;/*horizontalAlignment: Text.AlignHCenter;*/ style: Text.Raised;font.pointSize: 32
    anchors.horizontalCenter: parent.horizontalCenter
    }

    Text{id:nowVolu;color: "skyblue"; text: player.volume * 100 ; font.family: myFont.name; style: Text.Raised;font.pointSize: 17
        opacity: overlayControlsMA.containsMouse ? 0.8 : 0.0
        anchors.topMargin: 15
        z:fullscrner.containsMouse ? 100000 :1000
        Behavior on opacity {
        NumberAnimation { duration: 450; easing.type: Easing.OutQuad }
        }
        anchors.horizontalCenter: parent.horizontalCenter
    anchors.top:nowTimer.bottom
    }

    Image {
        id: navf
        anchors.right: parent.right
        source: "navf.png"
        scale: fordnavM.pressed && fordnavM.containsMouse ? 0.7 : 1.0
        opacity: fordnavM.pressed && fordnavM.containsMouse ? 0.2 : 0.5
        Behavior on scale {
            NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
        }
//        Behavior on opacity {
//            NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
//        }
        MouseArea{ id:fordnavM;anchors.fill: parent ;onClicked: tabholder.selectedTabIndex = 2

        }

    }




}

Item{width:root.width ; y:80
Text{id:nowPlayin;x:30; y:50; color: "#ffffff"; text:" ♪  " + player.metaData.title ; font.family: myFont4meta.name;   horizontalAlignment: Text.AlignHCenter;  font.pointSize: 20


 NumberAnimation {id: playbanner2; running: false
                    target:nowTimer; easing.type: Easing.OutBack; property: "x"; from: root.width; to: nowTimer.x; duration: 400 }
 NumberAnimation {id: playbanner; running: false
                 target:nowPlayin; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 30; duration: 600 }



    MouseArea {
        anchors.fill: parent
        drag.target: nowPlayin; drag.axis: Drag.XAxis
            }

}
}
 }



    Text{id:albumtitle; x:30;y:parent.height - 180 ;color: "#ffffff"; text:"Album : " + player.metaData.albumTitle ; font.family: myFont4meta.name; horizontalAlignment: Text.AlignHCenter;  font.pointSize: 18}
    Text{id:albumartist; x:30;y:parent.height - 138 ; color: "#ffffff"; text:"Artist : " + player.metaData.albumArtist ; font.family: myFont4meta.name; horizontalAlignment: Text.AlignHCenter;  font.pointSize:18}
    Text{id:composer;x:30;y:parent.height - 96  ;color: "#ffffff"; text:"Composer : " + player.metaData.composer ; font.family: myFont4meta.name; horizontalAlignment: Text.AlignHCenter;  font.pointSize: 18}
    Text{id:genere;x:30;y:parent.height - 54  ;color: "#ffffff"; text:"Genre : " + player.metaData.genre ; font.family: myFont4meta.name; horizontalAlignment: Text.AlignHCenter;  font.pointSize: 18}

    NumberAnimation {id: playbanner3; running: false
                       target:albumtitle; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 30; duration: 600 }
    NumberAnimation {id: playbanner4; running: false
                    target:albumartist; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 30; duration: 700 }
    NumberAnimation {id: playbanner5; running: false
                       target:composer; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 30; duration: 800 }
    NumberAnimation {id: playbanner6; running: false
                    target:genere; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 30; duration: 900 }

                    }
//End Currentplaying information ,,, Need hard work too



            MediaPlayer{
               id:player
               autoPlay: true
               autoLoad: false
              // volume: liveSliderr.value
               onStatusChanged: {
                   if (status===MediaPlayer.EndOfMedia) {
                       next()
                       index=playlist.currentIndex

                   }


                 }

                onVolumeChanged: {
          volumeer.anglee= 180 * player.volume + 270
                    //console.log(volumeer.anglee)
                }
               // Only used for debugging purposes.
//               onStopped: {
//                   console.log("Stopped signal received!");
//               }

               function playPause() {
                   if (player.playbackState === MediaPlayer.PlayingState)
                       player.pause();
                   else if (player.playbackState === MediaPlayer.PausedState)
                       player.play();
                   else if (player.playbackState === MediaPlayer.StoppedState)
                       player.play();
                    }
                   function volumeUp() {
                      volume  = (volume + 0.1 > 1) ? 1 : volume + 0.1;
                     liveSliderr.value= player.volume
                   }

                   function volumeDown() {
                     volume = (volume - 0.1 < 0) ? 0 : volume - 0.1;
                     liveSliderr.value= player.volume
                   }



            // start reloading infomodel since the previous tags can be from user (custom search)
             //  onPlaybackStateChanged: {console.log("current infomodel source from mediaplayer logger "+infomodel.source)}
             // end reloading infomodel since the previous tags can be from user (custom search)
               }

            //start binding of player volume with volume slider (id:liveSlidder) needed because when keyup is pressed from keyboard lider value was not changing ....fixed now :D
             Binding { target: player; property: "volume"; value: liveSliderr.value; when: player.hasAudio}
            //end binding of player volume with volume slider (id:liveSlidder) needed because when keyup is pressed from keyboard lider value was not changing ....fixed now :D


//seeker stylish
             //wrapper
             Rectangle{
 id: progressBarWrapper
  z:fullscreened ? 1006 : 1000
             height:vidmode.checked? 40 :25
             color:"transparent"
             anchors.left: parent.left
             anchors.right: parent.right

             anchors.bottom: parent.bottom
             MouseArea {
                 id:seekermaaa
                 property int pos
                  anchors.fill:progressBarWrapper
                  hoverEnabled: true
                  onClicked: {
                  if (player.seekable)
                      pos = player.duration * mouse.x/width
                      player.seek(pos)
                  }
                  onEntered: {progressBar.height= 8 ;/* console.log("entererd")*/}
                  onExited: {progressBar.height= 2 }
                  onWheel:  {
                                      if (wheel.angleDelta.y < 0)
                                      liveseeker.value=liveseeker.value-6000;

                                      else
                                      liveseeker.value=liveseeker.value+6000;





                  }
             }

             //main seeker start
            Rectangle {
                id: progressBar
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.bottom: parent.bottom
                anchors.margins: fullscreened ? 15 : 7

                //visible: vidmode.checked  ? true : false
                height:2
                color: "transparent"
                //opacity: 0.8
                Behavior on anchors.margins {
                        NumberAnimation { duration: 600; easing.type : Easing.OutQuad  }
                    }
                Behavior on height  { NumberAnimation { duration: 400; easing.type : Easing.OutQuad  } }
                RectangularGlow {
                      id: effect
                      anchors.fill: progressBar
                      glowRadius:8
                     // spread: 0.1
                      color: "steelblue"
                      cornerRadius: progressBar.radius + glowRadius

                  }


                Rectangle {radius:effect.cornerRadius
                    id:innerSlider
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    gradient:  Gradient {

                        GradientStop { position: 0.0
                        color: "#7ABBD5"
                        }
                        GradientStop { position: 0.5
                        color: "#127DA8"
                        }
                        GradientStop { position: 1.0
                        color: "#73B5D0"
                        }
                      }
                    //source:"k.gif"
                    //playing: player.playbackState===MediaPlayer.PlayingState ? true :false
                   // fillMode: Image.TileHorizontally
                    width: player.duration>0?parent.width*player.position/player.duration:0
                   // color: "#53B5DD"
                     height: 3
                    Behavior on width {
                            NumberAnimation { duration: 600; easing.type : Easing.OutQuad  }
                        }

//                    AnimatedImage {

//                        id: animatedseeker
//                        playing: player.playbackState === MediaPlayer.PlayingState ? true :false
//                        source: "ll.gif"
//                        anchors.fill: parent
//                        fillMode: Image.TileHorizontally

//                    }

                }



            }


                }
 // progressBarWrapper end
            }
//end of  main Rectangle
         }



            //end player tab


//start current playing information tab
Tab{ title: i18n.tr("Info")

page:Page {
id: currentplayinginfo
title:i18n.tr("kMusicplay:"+player.metaData.title)
anchors.fill:parent

 //  property bool loading: infomodel.status===XmlListModel.Loading


ActivityIndicator {
    id: busyindicator
    objectName: "activityindicator_standard"
                  anchors.bottom: floatingtxt.top
                  anchors.horizontalCenter: parent.horizontalCenter

                  running: mainWindow.loading

}
Text {
    anchors.centerIn: parent
    id:floatingtxt
    anchors.top: busyindicator.bottom
    visible: infomodel.status != XmlListModel.Ready && mainWindow.loading
    horizontalAlignment:  Text.AlignHCenter
    text:"\n"+ "\n"+"Need Working Network Connection"+"\n"+"\n"+"Click Reload from Toolbar"; width: parent.width; wrapMode: Text.WordWrap ;
    font { family: myFont4meta.name; pointSize: 12 }
    color:"#808080"


}



ListView {
        id:playinginfor
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter

        model: XmlListModel {
            id: infomodel
            source: updateMeta
            namespaceDeclarations: "declare default element namespace 'http://api.chartlyrics.com/';"

            query: "/GetLyricResult"

             XmlRole { name: "title"; query: "LyricSong/string()" }

             XmlRole { name: "lyric"; query: "Lyric/string()" }

             XmlRole { name: "art"; query: "LyricCovertArtUrl/string()" }

             XmlRole { name: "artist"; query: "LyricArtist/string()" }


        }

        delegate:
            Item {
                id: delegate
                height: column.height + 40
                width: delegate.ListView.view.width



                Image{ id:albumart; source:art; opacity: 0.3; fillMode: Image.PreserveAspectCrop; anchors.fill: parent;}

                Column {
                    spacing: 2
                    id: column
                    x: 20; y: 20
                    width: parent.width

                    Text {
                        id: titleText
                        style: Text.Raised;styleColor: "#AAAAAA"
                        text: title  +" ("+ artist +")"; width: parent.width - 8; wrapMode: Text.WordWrap ;
                        font {  family: "Helvetica"; pointSize: 20 }
                        color:"#808080"
                        MouseArea{anchors.fill: parent;  drag.target:parent; drag.axis: Drag.XAxis}
                    }


                    Text {
                        id: lyricsText
                        width: parent.width - 8; text:"\n"+ lyric
                        wrapMode: Text.WordWrap; font.family: "Helvetica"
                        color:"#2E2E2E"
                        MouseArea{anchors.fill: parent;  drag.target:parent; drag.axis: Drag.XAxis}
                    }

                    NumberAnimation {id: playbanner13; running:true
                                       target:titleText; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 5; duration: 500 }
                    NumberAnimation {id: playbanner14; running: true
                                    target:lyricsText; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 5; duration: 700 }
                    NumberAnimation {id: playbanner15; running:true
                                       target:albumart; easing.type: Easing.OutBack; property: "x"; from: root.width; to: 0; duration: 900 }

                    //remove item
                    NumberAnimation {id: psudoplaybanner13; running: infomodel.status != XmlListModel.Ready
                                       target:titleText; easing.type: Easing.OutBack; property: "x"; from: 5; to: root.width; duration: 400 }
                    NumberAnimation {id: psudoplaybanner14; running: infomodel.status != XmlListModel.Ready
                                    target:lyricsText; easing.type: Easing.OutBack; property: "x"; from: 5; to: root.width; duration: 800 }
                    NumberAnimation {id: psudoplaybanner15; running: infomodel.status != XmlListModel.Ready
                                       target:albumart; easing.type: Easing.OutBack; property: "x"; from: 0; to: root.width; duration: 900 }
                }

            }





        }
    ScrollBar { scrollArea: playinginfor; height: playinginfor.height; width: 6; anchors.right: currentplayinginfo.right }


tools: ToolbarItems {
id:tooler


        ToolbarButton {
      iconName: "back"
      text: "Back"
      onTriggered: tabholder.selectedTabIndex = 1
                    }

        ToolbarButton {
          iconName: "system-shutdown"
          text: "Quit"
          onTriggered: PopupUtils.open(dialog, null)
                        }
        ToolbarButton {
          iconName: "favorite-unselected"
          text: "About"
          onTriggered: PopupUtils.open(dialogabout4button, null)
                        }

        ToolbarButton {
          iconName: "settings"
          text: "Setting"
          onTriggered: PopupUtils.open(settingspop, null)
                        }

         ToolbarButton {
                iconName: "media-skip-backward"
                text: "Previous"
                onTriggered: previous()
                              }
         ToolbarButton {
                iconName: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
                text: player.playbackState === MediaPlayer.PlayingState ? "Pause" : "play"
                onTriggered: player.playbackState === MediaPlayer.PlayingState ?  player.pause() : player.play()
                        }
         ToolbarButton {
                        iconName: "media-skip-forward"
                        text: "Next"
                        onTriggered: next()
                              }
         ToolbarButton {id:editmeta
                        iconName: "edit"
                        text: "Edit Tag"
                        onTriggered:{PopupUtils.open(editmetapopup, editmeta); }
                        }
         ToolbarButton {id:reloadmeta
                        iconName: "reload"
                        text: "Reload"
                        onTriggered:{
                            infomodel.source= "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist="+player.metaData.albumArtist+"&song="+player.metaData.title
                            infomodel.reload();
                        console.log("reloading "+infomodel.source)}
                        }


         ToolbarButton {
           iconName: "navigation-menu"
           text: "Library"
           onTriggered: tabholder.selectedTabIndex = 0
                         }

            }
//start setting popup component
Component {
    id: settingspop
     ComposerSheet {
         onVisibleChanged: if(visible===true)tooler.locked=true
         else if (visible===false) tooler.locked=false
        id: settingssheet
        title: i18n.tr("kMusicplay Settings")

        Column {id:parrntcolumn
            anchors.fill: parent
            anchors.margins: units.gu(5)
            spacing: units.gu(2)

            OptionSelector {
                id: savelastToggle
                text: i18n.tr("Save Last Played Library")
                model: [i18n.tr("Yes"), i18n.tr("No")]


            }
//            OptionSelector {
//                id: shuffuleToggle
//                text: i18n.tr("Shuffule tracks in Library")
//                model: [i18n.tr("Yes"), i18n.tr("No")]


//            }
            OptionSelector {
                id: loadvidoToggle
                text: i18n.tr("Load video in Library")
                model: [i18n.tr("Yes"), i18n.tr("No")]


            }

             }



        onCancelClicked: PopupUtils.close(settingssheet)
        onConfirmClicked: {
           if(savelastToggle.selectedIndex===0){


               setSetting("mySetting", folderModel.folder);
               setSetting("myLoadLastconditon", savelastToggle.selectedIndex )

               console.log("Saved setting to load"+ folderModel.folder +" in next session " );
           }
           else if (savelastToggle.selectedIndex===1){setSetting("mySetting", "");
           setSetting("myLoadLastconditon", savelastToggle.selectedIndex)
           console.log("Saved setting to  not load last playing library" );
            };


           if(loadvidoToggle.selectedIndex===0){setSetting("loadvid",loadvidoToggle.selectedIndex)
                setnamefilter()

           }
            else if (loadvidoToggle.selectedIndex===1){setSetting("loadvid",loadvidoToggle.selectedIndex)
                setnamefilter()
           }

            PopupUtils.close(settingssheet);}
        Component.onCompleted: {
        savelastToggle.selectedIndex = getSetting("myLoadLastconditon")
    //    shuffuleToggle.selectedIndex = getSetting("shuffule")
        loadvidoToggle.selectedIndex = getSetting("loadvid")
        }
                }

    }
//end setting popup component


    }

//end current playing information tab

}




//start custom tag lyric search popup component
Component {
    id: editmetapopup
     ComposerSheet {
         onVisibleChanged: if(visible===true)tooler.locked=true
         else if (visible===false) tooler.locked=false
        id: sheet
        title: i18n.tr("Search Lyrics by tag names")
        Column {
            anchors.centerIn: parent
            spacing: parent.height/8
                width:parent.width

            Image{  source: Qt.resolvedUrl("chartlyrics.png")
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: 0.6
            }

          TextField {id:titlemeta
                     width:parent.width
                     objectName: "textfield_standard"
                     placeholderText: i18n.tr("Type song title...")
                     hasClearButton:true
                text:player.metaData.title

                     }
          TextField {id:artistmeta
                     width:parent.width
                     objectName: "textfield_standard"
                     placeholderText: i18n.tr("Type song artist...")
                text:player.metaData.albumArtist
                     }
                }



        onCancelClicked: PopupUtils.close(sheet)
        onConfirmClicked: { infomodel.source="http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist="+artistmeta.text+"&song="+titlemeta.text
   //         console.log("edited tag model loading "+infomodel.source)
            PopupUtils.close(sheet);}
                }

    }
//end custom tag lyric search popup component
//start timer to update the infomodel source after  70 miliseconds of player loading file

     Timer {
         id:metaupdateTimer
         interval: 700; running:false ;
         onTriggered:  infomodel.source= updateMeta
    }

//endtimer to update the infomodel source after  70 miliseconds of player loading file


//start quit dialog called when user hit q button from keyboard
Component {
    id: dialog
    Dialog {
        id: dialogue

        title: "‣ kMusicplay"
        Image{source:Qt.resolvedUrl("branding.png") ;fillMode: Image.PreserveAspectFit}

        text: "Are you sure you want to quit ?"

        Button {
            text: "Cancel"
            gradient: UbuntuColors.greyGradient
            onClicked: PopupUtils.close(dialogue)
        }
        Button {
            text: "Help"
            gradient: UbuntuColors.greyGradient
            onClicked:{ PopupUtils.close(dialogue) ; /*tabholder.selectedTabIndex = 2*/PopupUtils.open(dialoghelp, null)}
        }
        Button {
            text: "About"
            gradient: UbuntuColors.greyGradient
            onClicked:{ PopupUtils.close(dialogue) ; /*tabholder.selectedTabIndex = 2*/PopupUtils.open(dialogabout, null)}
        }
        Button {
            text: "Quit"

            onClicked: Qt.quit()
        }
    }
}
//End quit dialog called when user hit q button from keyboard
//start about dialog
Component {
    id: dialogabout
    Dialog {
        id: dialoguee

        title: "About ‣ kMusicplay"
        Image{source:Qt.resolvedUrl("https://graph.facebook.com/keshav.bhatt.393/picture?redirect=true&height=100&width=100") ;fillMode: Image.PreserveAspectFit
        MouseArea{anchors.fill: parent;onClicked: Qt.openUrlExternally("https://facebook.com/keshav.bhatt.393")}}
        text: "Ver- 0.2"+"\n"+"\n"+"lp:keshavnrj/kmusicplay"+"\n"+"\n"+"© 2015, Keshav Bhatt"
        Image{fillMode: Image.PreserveAspectFit
             source: Qt.resolvedUrl("facebook.png")
           MouseArea{anchors.fill: parent; onClicked:  Qt.openUrlExternally("https://facebook.com/keshav.bhatt.393")
        }}
        Button {
            text: "Email Me"
            onClicked:  Qt.openUrlExternally("mailto: keshavnrj@gmail.com" +"?subject=Hi put your subject here :)" + "&body=kMusicplay" )
        }

        Button {
            text: "Back"
            gradient: UbuntuColors.greyGradient
            onClicked: {PopupUtils.close(dialoguee);PopupUtils.open(dialog, null)}
        }


    }
}
Component {
    id: dialogabout4button
    Dialog {
        id: dialogueee

        title: "About ‣ kMusicplay"
        Image{source:Qt.resolvedUrl("https://graph.facebook.com/keshav.bhatt.393/picture?redirect=true&height=100&width=100") ;fillMode: Image.PreserveAspectFit
        MouseArea{anchors.fill: parent;onClicked: Qt.openUrlExternally("https://facebook.com/keshav.bhatt.393")}}
        text: "Ver- 0.2"+"\n"+"\n"+"lp:keshavnrj/kmusicplay"+"\n"+"\n"+"© 2015, Keshav Bhatt"
        Image{fillMode: Image.PreserveAspectFit
             source: Qt.resolvedUrl("facebook.png")
           MouseArea{anchors.fill: parent; onClicked:  Qt.openUrlExternally("https://facebook.com/keshav.bhatt.393")
        }}
        Button {
            text: "Email Me"
            onClicked:  Qt.openUrlExternally("mailto: keshavnrj@gmail.com" +"?subject=Hi put your subject here :)" + "&body=kMusicplay" )
        }

        Button {
            text: "Okay"
            gradient: UbuntuColors.greyGradient
            onClicked: {PopupUtils.close(dialogueee)}
        }


    }
}
//end about dialog
//start help dialog
Component {
    id: dialoghelp
    Dialog {
        id: dialogueee

        title: "Shortcuts ‣ kMusicplay"
        text: "Select Library  "+"  »  "+"Ctrl+O"+"\n"+
              "Play Playback   "+"  »  "+"Ctrl+P"+"\n"+
              "Next Track       "+"    »  "+"Ctrl+Right"+"\n"+
              "Previous Track  "+"  »  "+"Ctrl+Left"+"\n"+
              "Pause Playback  "+"  »  "+"0 Key"+"\n"+
              "Seek Forward      "+"   »  "+"Left Arrow Key"+"\n"+
              "Seek Backward     "+"   »  "+"Right Arrow Key"+"\n"+
              "Volume Up         "+"   »  "+"Up Arrow Key"+"\n"+
              "Volume Down       "+"   »  "+"Down Arrow Key"+"\n"+
              "Quit Player      "+"    »   "+"Ctrl+Q Key"


        Button {
            text: "Back"
            gradient: UbuntuColors.greyGradient
            onClicked: {PopupUtils.close(dialogueee);PopupUtils.open(dialog, null)}
        }


    }
}
//end help dialog

Component.onCompleted: {
    // Initialize the database
    initialize();
    setnamefilter();
    // Sets the playlist to  value we just set in previous session
    folderModel.folder = getSetting("mySetting");

    folderModel.nameFilters=["*.mp3","*.mp4","*.ogv","*.webm","*.avi","*.wmv","*.mkv","*.flv","*.oga", "*.ogg", "*.flac"," *.opus", "*.m4a","*.aac" ]
    playlist.currentIndex = items - 1
    playlist.update();



}
}
//ended tabholder

}
