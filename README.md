3du.tw (教育部重編國語辭典) Moe Dictionary App
-----------------------------
響應 3du.tw @g0v hackath1n |  台灣零時政府第壹次公地放領黑客松, 將教育部重編國語辭典製作為跨平台且未來可擴充及線上昇級之桌面端離線應用程式。

Moe Dictionary 是基於 [XULApp StarterKit] 開發。


軟體畫面
-----------------------------
![ScreenShot](https://s3.amazonaws.com/xulapp/moe-dict/moe-dict-screenshot.png)
![ScreenShot2](https://s3.amazonaws.com/xulapp/moe-dict/moe-dict-screenshot2.png)


下載執行檔案
-----------------------------

* [MacOSX Version](https://s3.amazonaws.com/xulapp/moe-dict/moe-dict.app-0.2.0.dmg)
* [Windows 32](https://s3.amazonaws.com/xulapp/moe-dict/moe-dict.app-0.2.0-win32.zip)
* [Linux i686](https://s3.amazonaws.com/xulapp/moe-dict/moe-dict.app-0.2.0-linux-i686.tar.bz2)
* [Linux x86_64](https://s3.amazonaws.com/xulapp/moe-dict/moe-dict.app-0.2.0-linux-x86_64.tar.bz2)


Build Moe Dictionary (Optional)
-----------------------------

1. Fork this project and clone.
2. Change BUILD_MAC / BUILD_LINUX / BUILD_WIN32 variables in config.sh to setting operating systems you want to build.
3. run fetch_xulrunner.sh to downloading xulrunner runtime from ftp.mozilla.org.[ONLY ONCE]
4. run fetch_moe_sqlite.sh to downloading dictionary databases.[ONLY ONCE]
5. run build.sh


Need Your Help
-----------------------------
1. Logo
2. UI Layout and CSS

ChangeLog
-----------------------------
0.2.0
* Databases 移至獨立 Add-on ，以便未來可以單獨線上昇級詞典資料庫。
* Wiktionary 維基詞典 Add-on ，方便其它開發者以此為藍本。
* 修正查詢結果無法選取問題。

License
-----------------------------
Moe Dictionary are licensed under the [MPL License](http://mozilla.org/mpl/2.0/).
See LICENSE for more details.


