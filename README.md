XULApp StarterKit
-----------------------------
XULApp StarterKit is a generic framework for XULRunner applications, like [Rich Client Platform](http://en.wikipedia.org/wiki/Rich_client_platform) .

It provides the "plumbing" that, before, every developer had to write themselves—saving state, connecting actions to menu items, toolbar items and keyboard shortcuts;
 window management, add-ons mechanism, update mechanism and so on.

XULApp StarterKit provides a reliable and flexible application architecture.
An architecture that encourages sustainable development practices. Because the XULApp StarterKit architecture is modular, it's easy to create applications that are ro
bust and extensible.


Included in the distribution package:

* A minimal XUL application with a main skeleton window and an about dialog
* Auto-load Modules by Preferences System.
* Integrated [GREUtils](https://github.com/racklin/greutils) .
* Integrated [lodash](https://github.com/bestiejs/lodash) .
* A bundled [HTTP server](https://developer.mozilla.org/en-US/docs/Httpd.js/HTTP_server_for_unit_tests) For HTML5 application or IPC.
* XULRunner 18 (Gecko 18)


XULApp StarterKit Build Scripts
-----------------------------
XULApp StarterKit include a collection of build scripts for packaging a XULRunner Application into distributable
bundles for Mac, Windows, and Linux.

Build Scripts is based on [Zotero Standalone build utility](https://github.com/zotero/zotero-standalone-build).


Benefits
-----------------------------

* Main skeleton window contains configurable Menubar , Toolbar , StatusBar.
* Latest HTML5 support (Same as Firefox 18, and easy to use new Gecko versions as they are released)
* Plugin support (Firefox plug-ins and extensions may be bundled with the application)
* [Application Updates](https://developer.mozilla.org/en-US/docs/XULRunner/Application_Update)
* Not only acting as a native desktop application, it **is** a native desktop application
* Working on the most widely used desktop operating systems, as well as 32- and 64-bit Linux (Wherever Firefox 18 runs, this runs)
* Installable from USB Stick / CD, Offline
* Offline usage
* Proven and well tested (indirectly through projects like Firefox)
* Not dependent on third party services for packaging and/or distribution
* I18n / L10n
* Auto-load Modules from XPCOM Service. All Modules will load once when startup.
* Registrable modules from preferences system, you can install modules by add-ons.


Download Pre-build Binary
-----------------------------
Download Pre-build XULApp Starterkit in [downloads](https://github.com/racklin/xulapp-starterkit/tree/master/downloads) .
Supports MacOSX / Linux i686 / Linux x86_64 / Win32


Get started
-----------------------------
Build XULApp StarterKit for your application:

1. Fork this project and checkout.
2. Change BUILD_MAC / BUILD_LINUX / BUILD_WIN32 variables in config.sh to setting operating systems you want to build.
3. Change Profile variable in config.sh to specifies the path to use for the application's profile. [XUL Application Packaging](https://developer.mozilla.org/en-US/docs/XUL_Application_Packaging)
4. Customize branding and metadata to your liking.
5. run fetch_xulrunner.sh to downloading xulrunner runtime from ftp.mozilla.org.[ONLY ONCE]
6. run build.sh


Make your own application
-----------------------------
### Application in XULApp StarterKit Project

app/ directory contains standard XULRunner application structure.
Put your application files in app/ directory and modify app/chrome/content/xulapp/xulapp.xul main window.

### Application as First Add-on (Recommended)

Make your application as add-on and install to XULApp StarterKit.
This will make your application more flexible.

### Example Application Add-ons For XULApp StarterKit:
* [HTML5 Webapp Wrapper](https://github.com/racklin/xulapp-starterkit-app-webapp-wrapper).
    * Wrap and Packaging your HTML5 Web Application to XPI add-on.
    * PhoneGap Like.
* [XUL Periodic Table](https://github.com/racklin/xulapp-starterkit-app-xul-periodic-table).

### Example and Useful Add-ons For XULApp StarterKit:
* [SQLite Manager 0.7.7](https://github.com/racklin/xulapp-starterkit-addon-sqlitemanager).
* [DOM Inspector 2.0.12](https://github.com/racklin/xulapp-starterkit-addon-dominspector).

Auto-Load Modules
-----------------------------
Register Your Modules in prefs.js , XULApp StarterKit Will auto-load when startup.
All Modules 's variables will in *XULApp* scope.

#### Register Notication Modules Example
In prefs.js Add:

```
pref("xulapp.modules.notification", "chrome://xulapp/content/modules/notification.js");
```

Now, You can using Notication Service from any pages.

```
var Notification = XULApp.Notification;
Notification.showNotication('Title', 'Text');
```


Tips
-----------------------------
### Generating icons
Use [http://iconverticons.com/](http://iconverticons.com/) to generate app icons for all platforms. Put your source image in icons/default/source folder and the gener
ated images in the icons/default folder.



License
-----------------------------
XULApp StarterKit are licensed under the [MPL License](http://mozilla.org/mpl/2.0/).
See LICENSE for more details.

