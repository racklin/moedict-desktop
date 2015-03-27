/** The below is imported from https://developer.mozilla.org/en/XULRunner/Application_Update **/
// Whether or not app updates are enabled
pref("app.update.enabled", true);

// This preference turns on app.update.mode and allows automatic download and
// install to take place. We use a separate boolean toggle for this to make
// the UI easier to construct.
pref("app.update.auto", true);

// Defines how the Application Update Service notifies the user about updates:
//
// AUM Set to:        Minor Releases:     Major Releases:
// 0                  download no prompt  download no prompt
// 1                  download no prompt  download no prompt if no incompatibilities
// 2                  download no prompt  prompt
//
// See chart in nsUpdateService.js.in for more details
//
pref("app.update.mode", 1);

// If set to true, the Update Service will present no UI for any event.
pref("app.update.silent", false);
pref("app.update.showInstalledUI", true);

// Update service URL:
// You do not need to use all the %VAR% parameters. Use what you need, %PRODUCT%,%VERSION%,%BUILD_ID%,%CHANNEL% for example
pref("app.update.url", "https://xulapp.s3.amazonaws.com/moedict-desktop/update_%VERSION%_%BUILD_TARGET%.xml");

// URL user can browse to manually if for some reason all update installation
// attempts fail.
pref("app.update.url.manual", "https://racklin.github.io/moedict-desktop/");

// A default value for the "More information about this update" link
// supplied in the "An update is available" page of the update wizard.
pref("app.update.url.details", "https://racklin.github.io/moedict-desktop/changelog.html");

// User-settable override to app.update.url for testing purposes.
//pref("app.update.url.override", "");

// Interval: Time between checks for a new version (in seconds)
//           default=1 day
pref("app.update.interval", 86400);

// Interval: Time before prompting the user to download a new version that
//           is available (in seconds) default=1 day
pref("app.update.nagTimer.download", 86400);

// Interval: Time before prompting the user to restart to install the latest
//           download (in seconds) default=30 minutes
pref("app.update.nagTimer.restart", 1800);

// The minimum delay in seconds for the timer to fire.
// default=2 minutes
pref("app.update.timerMinimumDelay", 120);

// Whether or not we show a dialog box informing the user that the update was
// successfully applied. This is off in Firefox by default since we show a
// upgrade start page instead! Other apps may wish to show this UI, and supply
// a whatsNewURL field in their brand.properties that contains a link to a page
// which tells users what's new in this new update.
pref("app.update.showInstalledUI", false);

// 0 = suppress prompting for incompatibilities if there are updates available
//     to newer versions of installed addons that resolve them.
// 1 = suppress prompting for incompatibilities only if there are VersionInfo
//     updates available to installed addons that resolve them, not newer
//     versions.
pref("app.update.incompatible.mode", 0);

// update channel for this build
pref("app.update.channel", "default");

pref("extensions.update.enabled", true);
pref("extensions.update.interval", 86400);
pref("extensions.update.autoUpdateDefault", true);
pref("extensions.update.url", "https://xulapp.s3.amazonaws.com/moedict-desktop/addons/%ITEM_ID%/update.rdf");
pref("extensions.update.background.url", "https://xulapp.s3.amazonaws.com/moedict-desktop/addons/%ITEM_ID%/update.rdf");

pref('extensions.moedictApp.whitelists.xulapps3', 'xulapp.s3.amazonaws.com');
pref('extensions.moedictApp.whitelists.racklingithub', 'racklin.github.io');
pref('extensions.moedictApp.whitelists.github', 'github.com');
pref('extensions.moedictApp.whitelists.racklingithub', 'dl.dropboxusercontent.com');
pref('extensions.moedictApp.whitelists.localhost', '127.0.0.1');
pref('extensions.moedictApp.whitelists.localhost1', 'localhost');
pref('extensions.moedictApp.whitelists.moedict', 'app.moedict.org');

