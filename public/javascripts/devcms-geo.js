function showAddress(address) {
  geocoder = new GClientGeocoder()
  geocoder.setViewport(map.getBounds())
  geocoder.getLocations(address, panAndZoomTo)
}

function panAndZoomTo(address) {
  bounds = address.Placemark[0].ExtendedData.LatLonBox
  map.centerAndZoomOnBounds(new GLatLngBounds(new GLatLng(bounds.south, bounds.west), new GLatLng(bounds.north, bounds.east)))
}
