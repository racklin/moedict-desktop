var isMoedictDesktop = window.moedictDesktop? true : false;

/*
// debug veriables for browser
window.moedictDesktop={};
window.moedictDesktop.installedAddons = [{id: 'moedict-addon-app@moedict.tw', name: 'Moedict App', version: '1.0.0'}];
isMoedictDesktop = true;
*/

function initHeaderContainer() {
    if (isMoedictDesktop) {
        var doms = document.querySelectorAll('.browser');
        for (var i=0; i<doms.length; i++) {
            doms[i].style.display ='none';
        }
        var doms = document.querySelectorAll('.moedict-desktop');
        for (var i=0; i<doms.length; i++) {
            doms[i].style.display ='';
        }
    }
}

function initAddonsLink() {
    // map installedAddons array to object
    var installedAddons = window.moedictDesktop.installedAddons;
    var installedAddonsObj = {};
    installedAddons.forEach(function(d) {
        installedAddonsObj[d.id] = d;
    });

    // process link
    var links = document.querySelectorAll('.item a');
    for (var i=0; i < links.length; i++) {
        var link = links[i];
        var lId = link.getAttribute('id');
        var lVersion = link.getAttribute('version');

        if (installedAddonsObj[lId]) {
            // has installed
            var instObj = installedAddonsObj[lId];
            if (instObj.version == lVersion) {
                link.className ='installed';
                link.innerHTML = '已安裝';
                link.disabled = true;
                continue;
            } else {
                link.className ='update';
                link.innerHTML = '＋昇級';
                continue;
            }
        }

        // replace download to install
        link.innerHTML = '＋安裝';
    }

}

function backToMoedictDesktop() {
    var href="https://moedict.tw/";
    if (isMoedictDesktop) {
        href = "http://" + window.moedictDesktop.bindAddress + ':' + window.moedictDesktop.port + '/';
    }
    location.href=href;
}

function installAddon(src) {
    if (isMoedictDesktop) {
        window.moedictDesktop.installAddonForURL(src);
        return false;
    }
    return true;
}

window.addEventListener('DOMContentLoaded', function() {
    initHeaderContainer();
    if (isMoedictDesktop) initAddonsLink();
});
