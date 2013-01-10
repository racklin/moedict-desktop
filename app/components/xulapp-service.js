
const Cc = Components.classes;
const Ci = Components.interfaces;
const consoleLog = Components.utils.reportError;
const loadSubScript = Cc["@mozilla.org/moz/jssubscript-loader;1"].getService(Ci.mozIJSSubScriptLoader).loadSubScript;

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource://gre/modules/Services.jsm");


var isFirstLoadThisSession = true;
var zContext = null;

XULAppContext = function() {}
XULAppContext.prototype = {

	"Cc":Cc,
	"Ci":Ci

};


/**
 * The class from which the XULApp global XPCOM context is constructed
 *
 * @constructor
 * This runs when XULAppService is first requested to load all applicable scripts and initialize
 * XULApp. Calls to other XPCOM components must be in here rather than in top-level code, as other
 * components may not have yet been initialized.
 */
function makeXULAppContext() {
    if(zContext) {
        // Swap out old zContext
        var oldzContext = zContext;
        // Create new zContext
        zContext = new XULAppContext();
        // Swap in old XULApp object, so that references don't break, but empty it
        zContext.XULApp = oldzContext.XULApp;
        for(var key in zContext.XULApp) delete zContext.XULApp[key];
    } else {
        zContext = new XULAppContext();
        zContext.XULApp = {};
    }

    zContext.XULApp.__exposedProps__ = {};

    // setting free variable 'global' for XULApp
    zContext.XULApp['global'] = zContext.XULApp;

    // Load GREUtils first
    loadSubScript('chrome://xulapp/content/modules/GREUtils.js', zContext.XULApp);
    zContext.XULApp.__exposedProps__.GREUtils = "r";

    var GREUtils = zContext.XULApp.GREUtils;

    // Get 3rd-party registered modules
    var prefsService = Services.prefs;
    var prefXULAppBranch = prefsService.getBranch('xulapp.');

    // load modules
    prefXULAppBranch.getChildList('modules').forEach(function(key) {
        var moduleUrl = GREUtils.Pref.getPref(key, prefXULAppBranch);
        try {
            delete zContext.XULApp['EXPORTED_SYMBOLS'];
            loadSubScript(moduleUrl, zContext.XULApp);

            // automatic added __exposedProps__ for module
            if(zContext.XULApp['EXPORTED_SYMBOLS'] && zContext.XULApp['EXPORTED_SYMBOLS'].length >0) {
                zContext.XULApp['EXPORTED_SYMBOLS'].forEach(function(exportSymbol) {
                    zContext.XULApp.__exposedProps__[exportSymbol] = "r";
                });
            }

        } catch (e) {
            consoleLog("Error loading module: " +moduleUrl, zContext);
            dump("Error loading module: " +moduleUrl + "\n");
        }
    });

}


/**
 * The class representing the XULApp service
 */
function XULAppService() {
	try {
		var start = Date.now();

		if(isFirstLoadThisSession) {
            makeXULAppContext(false);
		}
		isFirstLoadThisSession = false;
		this.wrappedJSObject = zContext.XULApp;

		dump("Initialized in "+(Date.now() - start)+" ms" + "\n\n");
        consoleLog("Initialized in "+(Date.now() - start)+" ms" + "\n\n");
	} catch(e) {
		var msg = typeof e == 'string' ? e : e.name;
		dump(e + "\n\n");
        consoleLog(e);
		throw e;
	}
}

XULAppService.prototype = {
	contractID: '@xulapp-starterkit/xulapp-service;1',
	classDescription: 'XULApp Service',
	classID: Components.ID('{b0c32b3c-5964-11e2-90a5-000c29636bba}'),
	QueryInterface: XPCOMUtils.generateQI([Ci.nsIDOMGlobalPropertyInitializer, Ci.nsISupports]) ,


    init: function (aWindow) {
        return zContext.XULApp;
    }
}

/**
* XPCOMUtils.generateNSGetFactory was introduced in Mozilla 2 (Firefox 4).
* XPCOMUtils.generateNSGetModule is for Mozilla 1.9.2 (Firefox 3.6).
*/
if (XPCOMUtils.generateNSGetFactory) {
	var NSGetFactory = XPCOMUtils.generateNSGetFactory([XULAppService]);
} else {
	var NSGetModule = XPCOMUtils.generateNSGetModule([XULAppService]);
}
