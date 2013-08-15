showAddress = (address) ->
  geocoder = new GClientGeocoder()
  geocoder.setViewport(window.map.getBounds())
  geocoder.getLocations(address, panAndZoomTo)

panAndZoomTo = (address) ->
  ll = address.Placemark[0].Point.coordinates;
  ll = new GLatLng(ll[1], ll[0]);
  # Add marker on given location, remove the old one
  #if mapCenterMarker then map.removeOverlay(mapCenterMarker)
  #mapCenterMarker = new GMarker(ll)
  #map.addOverlay(mapCenterMarker)
  #mapCenterMarker.setImage("/images/icons/red-pushpin.png")
  bounds = address.Placemark[0].ExtendedData.LatLonBox
  bounds = new GLatLngBounds(new GLatLng(bounds.south, bounds.west), new GLatLng(bounds.north, bounds.east))

  zoomTarget = map.getBoundsZoomLevel(bounds)
  currentZoom = map.getZoom()
  centered = false

  if currentZoom < zoomTarget
    while currentZoom < zoomTarget
      window.map.zoomIn(ll, true, true)
      currentZoom += 1
  else if currentZoom == zoomTarget
    window.map.panTo(ll)
  else
    while currentZoom > zoomTarget
      window.map.zoomOut(ll, true)
      currentZoom -= 1

jQuery ->
  originalMarkerImages = {}
  
  $('.marker-link').click (event) ->
    event.preventDefault()
    if window.map
      linkId = $(this).attr('id')
      marker = markers[linkId]

      # Reset other markers
      for key in markers
        otherMarker = markers[key]
        if originalMarkerImages[key] && otherMarker != marker then otherMarker.setImage(originalMarkerImages[key])
      
      if !originalMarkerImages[linkId] then originalMarkerImages[linkId] = marker.Na.image
      marker.setImage("/pins/highlighted_pin?pin=" + encodeURIComponent(marker.Na.image))
      GEvent.trigger(marker, 'click')
  
  $('form#geo_viewer_location_form').submit (event) -> 
    event.preventDefault()
    showAddress $('#location', $(this)).val()

