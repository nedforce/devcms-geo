showAddress = (address) ->
  geocoder = new google.maps.Geocoder()
  geocoder.geocode({ address: address, bounds: window.map.getBounds() }, panAndZoomTo)

panAndZoomTo = (address) ->
  if address[0] && address[0].geometry
    ll = address[0].geometry.location
    bounds = address[0].geometry.bounds

    zoomTarget = getZoomByBounds(bounds)
    currentZoom = window.map.getZoom()
    centered = false
        
    window.map.panTo(ll)
    if currentZoom < zoomTarget
      while currentZoom < zoomTarget
        window.map.setZoom currentZoom
        currentZoom += 1
    else if currentZoom > zoomTarget
      while currentZoom > zoomTarget
        window.map.setZoom currentZoom
        currentZoom -= 1

getZoomByBounds = (bounds) ->
  MAX_ZOOM = window.map.mapTypes.get( map.getMapTypeId() ).maxZoom || 21
  MIN_ZOOM = window.map.mapTypes.get( map.getMapTypeId() ).minZoom || 0

  ne= window.map.getProjection().fromLatLngToPoint bounds.getNorthEast()
  sw= window.map.getProjection().fromLatLngToPoint bounds.getSouthWest()

  worldCoordWidth = Math.abs(ne.x-sw.x)
  worldCoordHeight = Math.abs(ne.y-sw.y)
  FIT_PAD = 40

  for zoom in [MAX_ZOOM..MIN_ZOOM] by -1
    return zoom if worldCoordWidth*(1<<zoom)+2*FIT_PAD < $(window.map.getDiv()).width() && worldCoordHeight*(1<<zoom)+2*FIT_PAD < $(window.map.getDiv()).height()

  return 0


jQuery ->
  originalMarkerIcons = {}
  
  $('.marker-link').click (event) ->
    event.preventDefault()
    if window.map
      linkId = $(this).attr('id')
      marker = window.markers[linkId]
      
      # Reset other markers
      $.each window.markers, (id, otherMarker) -> 
        if originalMarkerIcons[id] && otherMarker != marker then otherMarker.setIcon(originalMarkerIcons[id])
      
      if !originalMarkerIcons[linkId] then originalMarkerIcons[linkId] = marker.icon
      marker.setIcon "/pins/highlighted_pin?pin=#{encodeURIComponent(marker.icon)}" if marker.icon.indexOf('highlighted_pin') == -1
      google.maps.event.trigger marker, 'click'
  
  $('form#geo_viewer_location_form').submit (event) -> 
    event.preventDefault()
    showAddress $('#location', $(this)).val()

