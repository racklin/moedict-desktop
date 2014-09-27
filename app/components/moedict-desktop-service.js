
const Cc = Components.classes;
const Ci = Components.interfaces;
const consoleLog = Components.utils.reportError;
const loadSubScript = Cc["@mozilla.org/moz/jssubscript-loader;1"].getService(Ci.mozIJSSubScriptLoader).loadSubScript;

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource://gre/modules/Services.jsm");
Components.utils.import("resource://gre/modules/Preferences.jsm");

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

    var moedictSettings = zContext.XULApp;

    // moedict-app settings
    moedictSettings.enable = Preferences.get("extensions.moedictApp.httpServer.enabled", false);
    moedictSettings.bindAddress = Preferences.get("extensions.moedictApp.httpServer.bindAddress", "127.0.0.1");
    moedictSettings.port = Preferences.get("extensions.moedictApp.httpServer.port", 54321);
    moedictSettings.__exposedProps__.enable = "r" ;
    moedictSettings.__exposedProps__.bindAddress = "r" ;
    moedictSettings.__exposedProps__.port = "r" ;

    // voices pack settings
    var moedictAppBranch = Services.prefs.getBranch('extensions.moedictApp.');

    var voiceSettings = {__exposedProps__:{}};
    moedictAppBranch.getChildList('voices').forEach(function(key) {
        var voice = key.split('.')[1];
        if (voiceSettings[voice]) return;

        var pKey = 'extensions.moedictApp.voices.'+voice+'.path';
        var voicePath = Preferences.get(pKey, null);

        if (voicePath) {
            var url = moedictSettings.bindAddress+':'+moedictSettings.port+voicePath;
            voiceSettings[voice] = url;
            voiceSettings.__exposedProps__[voice] = "r";
        }

    });
    moedictSettings.voices = voiceSettings;
    moedictSettings.__exposedProps__.voices = "r";
}



function MoedictDesktopService() {
    try {
        var start = Date.now();

        if(isFirstLoadThisSession) {
            makeXULAppContext(false);
        }
        isFirstLoadThisSession = false;
        this.wrappedJSObject = zContext.XULApp;

        dump("MoedictDesktop Service Initialized in "+(Date.now() - start)+" ms" + "\n\n");
        consoleLog("MoedictDesktop Service Initialized in "+(Date.now() - start)+" ms" + "\n\n");

    } catch(e) {
        var msg = typeof e == 'string' ? e : e.name;
        dump(e + "\n\n");
        consoleLog(e);
        throw e;
    }
}

MoedictDesktopService.prototype = {
    contractID: '@moedict.tw/moedict-desktop-service;1',
    classDescription: 'MoedictDesktop Service',
    classID: Components.ID('{d9adcd75-1904-4732-9071-0b9e375f8200}'),
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
	var NSGetFactory = XPCOMUtils.generateNSGetFactory([MoedictDesktopService]);
} else {
	var NSGetModule = XPCOMUtils.generateNSGetModule([MoedictDesktopService]);
}
