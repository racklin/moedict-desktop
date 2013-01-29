/**
 * This object contains the various functions for the interface
 */
const MoeDictMainUI = new function() {

    var _ = XULApp._;
    var MoeDictDatabase = XULApp.MoeDictDatabase;

    this.searchDict = function() {

        var keyword = document.getElementById('search-keyword').value;

        keyword = keyword.replace('*', '%');

        var result = MoeDictDatabase.searchByTitle(keyword);

        this.resetList();

        this.refreshEntryList(result);

    }


    this.entryListItemSelected = function(evt) {

        var entryStr = evt.target.value;

        var entry = JSON.parse(entryStr);

        var hid = entry.id;

        var result = MoeDictDatabase.getDefinitions(hid);

        this.refreshEntryDetail(entry, result);


    }

    this.resetList = function() {

        var listObj = document.getElementById('entry-list');

        // removeAll
        while (listObj.itemCount > 0) listObj.removeItemAt(0);

    }

    this.resetDetail = function() {

        var captionObj = document.getElementById('entry-detail-caption');
        var bopomofoObj = document.getElementById('entry-detail-bopomofo');
        var bopomofo2Obj = document.getElementById('entry-detail-bopomofo2');
        var pinyinObj = document.getElementById('entry-detail-pinyin');
        var definationsObj = document.getElementById('entry-detail-definitions');

        captionObj.setAttribute('label', '');
        bopomofoObj.setAttribute('value', '');
        bopomofo2Obj.setAttribute('value', '');
        pinyinObj.setAttribute('value', '');

        // remove all
        while (definationsObj.firstChild) definationsObj.removeChild(definationsObj.firstChild);

    }


    this.refreshEntryList = function (result) {

        var count = _.size(result);
        var caption = "Result (" + count + ")";

        var captionObj = document.getElementById('entry-list-caption');
        var listObj = document.getElementById('entry-list');

        captionObj.setAttribute('label', caption);

        // removeAll
        while (listObj.itemCount > 0) listObj.removeItemAt(0);

        _.forEach(result, function(r) {
            listObj.appendItem(r.title +' ' + r.bopomofo, JSON.stringify(r));
        })  ;

        if (count > 0) {
            listObj.selectedIndex = 0;
        }else {
            this.resetDetail();
        }

    }

    this.refreshEntryDetail = function(entry, definitions) {

        var captionObj = document.getElementById('entry-detail-caption');
        var bopomofoObj = document.getElementById('entry-detail-bopomofo');
        var bopomofo2Obj = document.getElementById('entry-detail-bopomofo2');
        var pinyinObj = document.getElementById('entry-detail-pinyin');
        var definationsObj = document.getElementById('entry-detail-definitions');

        captionObj.setAttribute('label', entry.title);
        bopomofoObj.setAttribute('value', entry.bopomofo);
        bopomofo2Obj.setAttribute('value', entry.bopomofo2);
        pinyinObj.setAttribute('value', entry.pinyin);

        // remove all
        while (definationsObj.firstChild) definationsObj.removeChild(definationsObj.firstChild);

        _.forEach(definitions, function(def) {

            try {
                var box = document.createElement('groupbox');
                var typeCaption = document.createElement('caption');
                var description = document.createElement('description');

                typeCaption.setAttribute('label', def.type);

                var textnode = document.createTextNode(def.def);
                description.appendChild(textnode);

                box.appendChild(typeCaption);
                box.appendChild(description);

                definationsObj.appendChild(box);
            }catch (e) {
                dump(e);
            }

        });



    }

}
