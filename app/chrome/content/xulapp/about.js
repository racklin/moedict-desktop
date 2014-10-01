Components.utils.import("resource://gre/modules/Services.jsm");

window.addEventListener('DOMContentLoaded', function() {
    var objVersion = document.getElementById('version');

    var version = Services.appinfo.version;

    objVersion.setAttribute('value', version);
});
