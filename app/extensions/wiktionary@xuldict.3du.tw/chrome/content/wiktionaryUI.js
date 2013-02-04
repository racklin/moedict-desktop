/**
 * This object contains the various functions for the interface
 */
const WiktionaryUI = new function() {

    var _ = XULApp._;

    var HOMEPAGE_URL = "http://zh.wiktionary.org/";
    var SEARCH_URL = "http://zh.wiktionary.org/wiki/%KEYWORD%";

    this.searchDict = function() {

        var browser = document.getElementById('wiktionary-browser');
        var keyword = document.getElementById('wiktionary-search-keyword').value;

        var url = HOMEPAGE_URL;
        if (keyword.length > 0 ) {

            url = SEARCH_URL;
            url = url.replace('%KEYWORD%', keyword);

            browser.loadURI( url, null, null );

        }


    }


}
