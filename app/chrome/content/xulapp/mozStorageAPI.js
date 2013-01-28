Components.utils.import("resource://gre/modules/Services.jsm");
Components.utils.import("resource://gre/modules/FileUtils.jsm");

/**
 * MoeDict Model
 */
const MozStorageAPI = new function() {

    this.openDatabaseURL = function(databaseUrl) {

        var url = Services.io.newURI(databaseUrl, null, null);
        var file = url.QueryInterface(Components.interfaces.nsIFileURL).file;

        return this.openDatabase(file)

    }


    this.openDatabaseFile = function(databaseFile) {

        var databaseUrl = 'file://'+databaseFile;

        return this.openDatabaseURL(databaseUrl);

    }

    this.openDatabase = function(file) {

        if (file.exists()) {
            return Services.storage.openDatabase(file);
        }else {
            return null;
        }

    }


    this.close = function(conn) {
        if (conn) conn.close();
    }


    this.query = function (conn, sql, params) {
        if (!conn) return null;

        var result = [];
        var columns = null;

        var statement = conn.createStatement(sql);

        try {

            while (statement.executeStep()) {

                if (!columns) {
                    // fetch columns first
                    columns = this.fetchColumns(statement);
                }

                var row = {};

                columns.forEach(function(col) {
                    row[col] = statement.row[col];
                });

                result.push(row);
            }

        }catch(e) {
            result = null;
        }finally {
            statement.reset();
        }

        return result;



    }

    this.fetchColumns = function(statement) {

        var columnCount = statement.columnCount;

        var columns = [];

        for (var i=0; i<columnCount; i++) {
            columns.push(statement.getColumnName(i));
        }

        return columns;

    }


}
