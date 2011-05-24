$.jQTouch({
    icon: 'jqtouch.png',
    statusBar: 'black-translucent'
});

function initGPS()
{
	navigator.geolocation.getCurrentPosition(getLocation, unknownLocation);
}
 
function getLocation(pos)
{
	var latitude = pos.coords.latitude;
	var longitude = pos.coords.longitude;
	alert('Your current coordinates (latitude,longitude) are : ' + latitude + ', ' + longitude);
}

function unknownLocation()
{
	alert('Could not find location');
}
