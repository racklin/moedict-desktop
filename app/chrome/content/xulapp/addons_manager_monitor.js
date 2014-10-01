Components.utils.import("resource://gre/modules/Services.jsm");
Components.utils.import("resource://gre/modules/AddonManager.jsm");

var addonsObjList = {};

function hideAddonsMonitor() {
    document.getElementById('addons-manager-monitor-container').hidden=true;
}

function showAddonsMonitor() {
    document.getElementById('addons-manager-monitor-container').hidden=false;
}

function appendAddonItem(aInstall) {

    var url = aInstall.sourceURI.spec;
    var filename = url.split('/').pop();

    var rows = document.getElementById('addons-manager-monitor-rows');
    var row = document.createElement('row');

    var l = document.createElement('label');
    l.setAttribute('value', filename);

    var p = document.createElement('progressmeter');
    p.setAttribute('value', 0);

    var l2 = document.createElement('label');
    l2.setAttribute('value', '');

    var l3 = document.createElement('label');
    l3.value = 'New Install';

    row.appendChild(l);
    row.appendChild(p);
    row.appendChild(l2);
    row.appendChild(l3);

    rows.appendChild(row);

    // cached by filename
    addonsObjList[filename] = {row: row, name: l, progress: p, dl: l2, status: l3};
}

function bytesToSize(bytes) {
       var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
          if (bytes == 0) return '0 Byte';
             var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
                return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
};

function updateAddonProgress(aInstall) {
    var url = aInstall.sourceURI.spec;
    var filename = url.split('/').pop();

    if (addonsObjList[filename]) {
        var p = addonsObjList[filename].progress;
        p.setAttribute('max', aInstall.maxProgress);
        p.setAttribute('value', aInstall.progress);

        var dl = addonsObjList[filename].dl;
        dl.setAttribute('value', '('+bytesToSize(aInstall.progress)+'/'+bytesToSize(aInstall.maxProgress)+')');

        var status = addonsObjList[filename].status;
        status.setAttribute('value', 'Downloading...');
    }
}

function installAddonStarted(aInstall) {
    var url = aInstall.sourceURI.spec;
    var filename = url.split('/').pop();

    if (addonsObjList[filename]) {

        var dl = addonsObjList[filename].dl;
        dl.setAttribute('value', '('+aInstall.progress+'/'+aInstall.maxProgress+')');

        var status = addonsObjList[filename].status;
        status.setAttribute('value', 'Installing...');
    }
}

function installAddonEnded(aInstall, addon) {
    var url = aInstall.sourceURI.spec;
    var filename = url.split('/').pop();

    if (addonsObjList[filename]) {
        var status = addonsObjList[filename].status;
        status.setAttribute('value', 'Installed');
    }

    // popup message
    XULApp.Notification.info(addon.name+' 安裝成功', '您需要重新啟動 Moedict Desktop');

}

AddonManager.addInstallListener({
    onNewInstall: function(aInstall) {
        showAddonsMonitor();
        appendAddonItem(aInstall);
    },

    onDownloadProgress: function(aInstall) {
        updateAddonProgress(aInstall);
    },

    onInstallStarted: function(aInstall) {
        installAddonStarted(aInstall);
    },

    onInstallEnded: function(aInstall, addon) {
        installAddonEnded(aInstall, addon);
    }

});

