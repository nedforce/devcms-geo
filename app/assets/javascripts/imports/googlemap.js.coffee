$.fn.googlemap = () ->
  this.each ->
    mapElement = $(this)
    element = mapElement.get(0)
    mapProperties = mapElement.data('map')
    
    zoomLevel = mapProperties.zoom || 7  
    bounds  = mapProperties.bounds
    pins    = mapProperties.pins
    markers = mapProperties.markers

    if mapProperties.size
      [width, height] = mapProperties.size.split('x')
      mapElement.css({width: Number(width), height: Number(height), background: '#fff'})

    wrapperElem = mapElement.wrap('<div class="map-wrap"/>').css({background:'#fff'})
  
    mapOptions =
      mapTypeControl: true
      overviewMapControl: false
      scrollwheel: false        
      mapTypeId: google.maps.MapTypeId.ROADMAP    
      zoom: zoomLevel
      zoomControlOptions:
        style:google.maps.ZoomControlStyle.SMALL

    window.map = new google.maps.Map(element, mapOptions)
    window.map.fitBounds(new google.maps.LatLngBounds(new google.maps.LatLng(bounds[0][0], bounds[0][1]), new google.maps.LatLng(bounds[1][0], bounds[1][1])))
    window.markers = {}

    $.each markers, (id, marker) ->
      infowindow = new google.maps.InfoWindow()

      gMarker = new google.maps.Marker
        position: new google.maps.LatLng(marker.lat, marker.lng)
        map: window.map
        title: marker.title
        icon: pins[marker.pin_id].image
        content: marker.info_window
      
      google.maps.event.addListener(gMarker, 'click', () ->
        infowindow.setOptions
          content: marker.info_window
        infowindow.open(window.map, gMarker)
      )

      window.markers[id] = gMarker

$ -> $('div[data-map]').googlemap()
