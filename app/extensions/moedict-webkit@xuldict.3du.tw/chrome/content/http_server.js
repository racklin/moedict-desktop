(function(){

    var initilized = false;
    var enable = false;
    var bindAddress = "127.0.0.1";
    var port = 54321;

    function initHttpServer() {

        const GREUtils = XULApp.GREUtils;

        var server = new XULApp.HttpServer();

        var indexPath = GREUtils.File.chromeToPath('chrome://webapp/content/index.html');

        // convert path string to nsFile
        var file = GREUtils.File.getFile(indexPath);
        var webappDir = file.parent;

        // serve webapp directory
        server.registerDirectory("/", webappDir);

        // httpd.js gets worried when there is no stop callback
        server._stopCallback = function() {
            dump("HTTP server stopped\n");
        }

        enable = GREUtils.Pref.getPref('extensions.webappWrapper.httpServer.enabled') || false;
        bindAddress = GREUtils.Pref.getPref('extensions.webappWrapper.httpServer.bindAddress') || "127.0.0.1";
        port = GREUtils.Pref.getPref('extensions.webappWrapper.httpServer.port') || 54321;

        try {
            if (enable) {
                server.start(port,  bindAddress);
                dump("HTTP server listening on ("+ bindAddress +"):"+server._port);
            }
        } catch(e) {
            dump("Not initializing HTTP server");
        }

    }

    initHttpServer();

    window.addEventListener('DOMContentLoaded', function(e) {
        if (!initilized) {
            var homePage = 'http://'+bindAddress+':'+port+'/';
            var webappBrowser = document.getElementById('webapp');
            if (webappBrowser) {
                webappBrowser.homePage = homePage;
                webappBrowser.loadURI(homePage);
            }
            initilized = true;
        }

    });

})();
