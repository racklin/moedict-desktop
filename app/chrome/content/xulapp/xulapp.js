/**
 * This object contains the various functions for the interface
 */
const MainUI = new function() {

	/**
	 * Opens the about dialog
	 */
	this.openAboutDialog = function() {
		window.openDialog('chrome://xulapp/content/about.xul', 'about', 'chrome');
	}

	/**
	 * Checks for updates
	 */
	this.checkForUpdates = function() {
		window.open('chrome://mozapps/content/update/updates.xul', 'updateChecker', 'chrome,centerscreen');
	}

    /**
     * opens the extension manager dialog
     */
    this.openAddonsMgr = function() {
        const EMTYPE = "Addons:Manager";
        var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
            .getService(Components.interfaces.nsIWindowMediator);
        var theEM = wm.getMostRecentWindow(EMTYPE);
        if (theEM) {
            theEM.focus();
            return;
        }

        const EMURL = "chrome://mozapps/content/extensions/extensions.xul";
        const EMFEATURES = "chrome,menubar,extra-chrome,toolbar,dialog=no,resizable";
        window.openDialog(EMURL, 'addonsManager', EMFEATURES);
    }

    /**
     * opens the error console
     */
    this.openErrorConsole = function() {
        const EMTYPE = "global:console";
        var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
            .getService(Components.interfaces.nsIWindowMediator);
        var theEM = wm.getMostRecentWindow(EMTYPE);
        if (theEM) {
            theEM.focus();
            return;
        }

        const EMURL = "chrome://global/content/console.xul";
        const EMFEATURES = "chrome,menubar,extra-chrome,toolbar,dialog=no,resizable";
        window.openDialog(EMURL, 'errorConsole', EMFEATURES);
    }
}
