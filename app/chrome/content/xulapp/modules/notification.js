/**
 *
 * Notification Utils Porting from VIVIPOS SDK
 *
 * Copyright (c) 2007 Rack Lin (racklin@gmail.com)
 *
 */
this.EXPORTED_SYMBOLS  = ['Notification'];

Components.utils.import("resource://gre/modules/Services.jsm");

this.Notification = new function() {

    var worker = Services.tm.mainThread;
    var notificationService = Components.classes["@mozilla.org/alerts-service;1"].getService(Components.interfaces.nsIAlertsService);

    this.__exposedProps__ = {
        showNotification: "r",
        trace: "r",
        debug: "r",
        info: "r",
        warn: "r",
        error: "r",
        fatal: "r"
    };

    this.showNotification = function(title, text, image, textClickable, cookie, alertListener, name) {

        image = image || "";
        textClickable = textClickable || false;
        cookie = cookie || "";
        alertListener = alertListener || null
        name = name || "";

        var runnable = {
            run: function() {
                try {

                    var imageUrl = '';
                    switch(image) {
                        case '':
                        case 'dialog-information':
                            imageUrl = "chrome://global/skin/icons/information-48.png";
                            break;
                        case 'dialog-warning':
                            imageUrl = "chrome://global/skin/icons/warning-large.png";
                            break;
                        case 'dialog-error':
                            imageUrl = "chrome://global/skin/icons/error-48.png";
                            break;
                        default:
                            imageUrl = image;
                            break;
                    }

                    notificationService.showAlertNotification(imageUrl, title, text, textClickable, cookie, alertListener, name);

                }catch(e) {
                    dump(e);
                }
            }
        };

        worker.dispatch(runnable, worker.DISPATCH_NORMAL);

    };

    this.trace = function(title, text, image) {

        image = image || "dialog-information";
        this.showNotification(title, text, image);

    };

    this.debug = function(title, text, image) {

        image = image || "dialog-information";
        this.showNotification(title, text, image);

    };

    this.info = function(title, text, image) {

        image = image || "dialog-information";
        this.showNotification(title, text, image);

    };

    this.warn = function(title, text, image) {

        image = image || "dialog-warning";
        this.showNotification(title, text, image);

    };

    this.error = function(title, text, image) {

        image = image || "dialog-error";
        this.showNotification(title, text, image);

    };

    this.fatal = function(title, text, image) {

        image = image || "dialog-error";
        this.showNotification(title, text, image);
    };

};
