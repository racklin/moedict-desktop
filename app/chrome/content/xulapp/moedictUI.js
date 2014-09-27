/**
 * This object contains the various functions for the interface
 */
const moedictUI = new function() {

    this.switchToAddonContainer = function(addon) {
        var deckObj = document.getElementById('addons-content-selector') ;
        var radioGroupObj = document.getElementById('addons-selector') ;

        var deckId = addon + '-ui-container';
        var iconId = addon + '-icon';

        var addonDeckObj = document.getElementById(deckId) ;
        var iconObj = document.getElementById(iconId) ;

        if (addonDeckObj && iconObj) {

            deckObj.selectedPanel = addonDeckObj;
            radioGroupObj.selectedItem = iconObj;

        }


    }
}

window.addEventListener('DOMContentLoaded', function(evt) {
        var radioGroupObj = document.getElementById('addons-selector') ;
        var radioContainerObj = document.getElementById('addons-container') ;

        if(radioGroupObj.itemCount <= 1) {
            radioContainerObj.hidden = true;
        }

});
