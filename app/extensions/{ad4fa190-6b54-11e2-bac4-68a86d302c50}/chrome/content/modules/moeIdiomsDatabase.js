this.EXPORTED_SYMBOLS  = ['MoeIdiomsDatabase'];

Components.utils.import("resource://gre/modules/Services.jsm");
Components.utils.import("resource://gre/modules/FileUtils.jsm");

/**
 * MoeDict Model
 */
this.MoeIdiomsDatabase = new function() {

    this._URL = "resource://moedict-idioms-databases/idioms.sqlite3";

    this._connection = null;



    this.getConnection = function() {

        if (this._connection) return this._connection;

        this._connection = MozStorageAPI.openDatabaseURL(this._URL);

        return this._connection;

    }


    this.closeConnection = function() {

        if (this._connection) MozStorageAPI.closeConnection(this._connection);
    }


    this.searchByTitle = function (title) {

        var conn = this.getConnection();

        var sql = "SELECT e.title, h.id, h.bopomofo, h.bopomofo2, h.pinyin FROM entries e INNER JOIN heteronyms h ON(e.id=h.entry_id) WHERE title like '"+title+"' LIMIT 100";

        var result = MozStorageAPI.query(conn, sql);

        return result;
    }

    this.getDefinitions = function (hid) {

        var conn = this.getConnection();

        var sql = "SELECT * FROM definitions d WHERE heteronym_id="+hid;

        var result = MozStorageAPI.query(conn, sql);

        return result;

    }


}
