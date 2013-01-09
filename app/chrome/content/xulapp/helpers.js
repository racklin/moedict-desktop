function gotoUrl(url)
{
	var nsioservice= Components.classes["@mozilla.org/network/io-service;1"]
	.getService(Components.interfaces.nsIIOService);

	var uri = nsioservice.newURI(url, null, null);

	var eps = Components.classes["@mozilla.org/uriloader/external-protocol-service;1"]
	.getService(Components.interfaces.nsIExternalProtocolService);

	eps.loadURI(uri, null);
}