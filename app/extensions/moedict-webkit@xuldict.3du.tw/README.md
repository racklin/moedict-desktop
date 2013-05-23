Webapp Wrapper For XULApp StarterKit
-----------------------------
Webapp Wrapper is a simple build script for XULApp StarterKit.

It packaging HTML5 Web Application as XULApp StarterKit's add-on.


Benefits
-----------------------------

* Latest HTML5 support (Same as Firefox 18, and easy to use new Gecko versions as they are released)
* Can using XULApp StarterKit Auto-load Modules .
* Bundled HTTP server (No local content restrictions like when using file:// protocol etc) .
  * Default bind address 127.0.0.1
  * Default listen port 54321


Download pre-build XPI
-----------------------------
Download pre-build XPI in [download XPI](https://github.com/racklin/xulapp-starterkit-app-webapp-wrapper/raw/master/downloads/xulapp-starterkit-webapp-wrapper-1.1.1.xpi)


Get started
-----------------------------
Build Webapp Wrapper for your web application:

1. Fork this project.
2. Copy your web application to webapp/ directory.
3. Change install.rdf and build.sh for your project name.
4. Change bind address or port in defaults/preferences/http.js.
5. run build.sh


Auto-Load Modules in HTML5
-----------------------------
In javascript you can using *XULApp* global variable to access Modules.

```
<p><a onclick="XULApp.Notification.info('Hello', 'World'); return false;">Demo XULApp XPCOM Notification</a></p>
```


License
-----------------------------
Webapp Wrapper For XULApp StarterKit are licensed under the [MPL License].
See LICENSE for more details.
