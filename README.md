3du.tw (教育部重編國語辭典) Moe Dictionary App
-----------------------------
響應 3du.tw @g0v hackath1n |  台灣零時政府第壹次公地放領黑客松, 將教育部重編國語辭典製作為跨平台且未來可擴充及線上昇級之桌面端離線應用程式。

Moe Dictionary 是基於 [XULApp StarterKit] 開發。


軟體畫面及下載
-----------------------------
請連結至官方網站 [Moedict Desktop](https://racklin.github.io/moedict-desktop/)


Build Moe Dictionary (Optional)
-----------------------------

1. Fork this project and clone.
2. Change BUILD_MAC / BUILD_LINUX / BUILD_WIN32 variables in `config.sh` to setting operating systems you want to build.
3. run `fetch_xulrunner.sh` to downloading xulrunner runtime from ftp.mozilla.org.[ONLY ONCE]
4. run `git submodule update --init --recursive` to update all submodules.
5. run build.sh


Need Your Help
-----------------------------
1. Logo
2. UI Layout and CSS

ChangeLog
-----------------------------
1.1.1
* 更新至最新(2015/03)版本之 moedict-app
* 線上更新網站支援 github.io .
* 支援將 1G 以上語音包分割為數個較小的語言包。

*
1.1.0
* 支援線上昇級
* 支援擴充套件安裝

1.0.0
* 使用 moedict.tw 離線 App 版本主程式。
* Gecko Engine 昇級至 29.0.1

0.3.0
* 使用 audreyt db2unicode.pl 將部份圖片字轉成 unicode 文字。
* 修正在 Windows / Linux 下功能選項出現 radio 按鈕。
* 新增 TonyQ 的教育部成語典。
* 全部程式碼移至各別 Add-ons 中，未來方便獨立小模組昇級。

0.2.0
* Databases 移至獨立 Add-on ，以便未來可以單獨線上昇級詞典資料庫。
* Wiktionary 維基詞典 Add-on ，方便其它開發者以此為藍本。
* 修正查詢結果無法選取問題。

License
-----------------------------
Moe Dictionary are licensed under the [MPL License](http://mozilla.org/MPL/2.0/).
See LICENSE for more details.


