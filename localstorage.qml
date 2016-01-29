
import QtQuick.LocalStorage 2.0
import QtQuick 2.0
import Ubuntu.Components 0.1

MainView {
    id: root
    // Note: applicationName sets the storage path
    applicationName: "com.ubuntu.developer.andrewsomething.example-app"

    width: units.gu(50)
    height: units.gu(75)

    property var db: null

    function openDB() {
        if(db !== null) return;

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("example-app", "0.1", "Simple example app", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
                var table  = tx.executeSql("SELECT * FROM settings");
                // Seed the table with default values
                if (table.rows.length===0) {
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["distro", "Ubuntu"]);
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["foo", "Bar"]);
                    console.log('Settings table added');
                };
            });
        } catch (err) {
            console.log("Error creating table in database: " + err);
        };
    }


    function saveSetting(key, value) {
        openDB();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES(?, ?)', [key, value]);
        });
    }

    function getSetting(key) {
        openDB();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT value FROM settings WHERE key=?;', [key]);
            res = rs.rows.item(0).value;
        });
        return res;
    }

    Page {
        id: app
        title: i18n.tr("Settings")

        Column {
            anchors.fill: parent
            anchors.margins: units.gu(5)
            spacing: units.gu(2)

            OptionSelector {
                id: distroToggle
                text: i18n.tr("Favorite Distro")
                model: [i18n.tr("Ubuntu"), i18n.tr("Debian")]
            }

            OptionSelector {
                id: fooToggle
                text: i18n.tr("Foo")
                model: [i18n.tr("Bar"), i18n.tr("Baz")]
            }

            Button {
                text: i18n.tr("Save settings")
                onClicked: {
                    var distro = (distroToggle.selectedIndex === 0) ? "Ubuntu" : "Debian";
                    console.log("Saved " + distro);
                    saveSetting("distro", distro);

                    var foo = (fooToggle.selectedIndex === 0) ? "Bar" : "Baz";
                    console.log("Saved " + foo);
                    saveSetting("foo", foo);
                }
            }
        }

        Component.onCompleted: {
            var distro = getSetting('distro');
            distroToggle.selectedIndex = (distro === "Debian") ? 1 : 0;
            var foo = getSetting('foo');
            fooToggle.selectedIndex = (foo === "Baz") ? 1 : 0;
        }
    }
}
