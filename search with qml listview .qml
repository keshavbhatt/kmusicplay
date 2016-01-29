import QtQuick 2.0
import QtQuick.Controls 1.0
import Qt.labs.folderlistmodel 2.1



Item {
    width: 300
    height: 300

    FolderListModel
    {
        id: folderListModel
    }

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
        folderListModel.nameFilters = [filter]
    }

    Row
    {
        spacing: 5
        Text {text:"Filter"}
        TextField
        {
            id: filterField
            onTextChanged: updateFilter()
        }

        Text {text:"Case Sensitive"}
        CheckBox
        {
            id: caseSensitiveCheckbox
            checked: false
            onCheckedChanged:updateFilter()
        }
    }

    ListView
    {
        anchors.fill: parent
        anchors.topMargin: 30
        model:folderListModel
        delegate: Text{text: model.fileName}
    }

}
