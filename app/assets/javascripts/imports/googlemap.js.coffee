showMarkers = ($mapElement) ->
  bounds = window.map.getBounds()
  sw = bounds.getSouthWest()
  ne = bounds.getNorthEast()

  $.get $mapElement.data('map'), { bounds: { sw: [sw.lat(), sw.lng()], ne: [ne.lat(), ne.lng()] } }, (map) ->
    window.markers ||= {}

    $.each window.markers, (id, marker) ->
      unless bounds.contains(marker.getPosition())
        marker.setMap(null)
        delete window.markers[id]

    pins = map.pins
    $.each map.markers, (id, marker) ->
      unless window.markers[id]
        gMarker = new google.maps.Marker
          id: id
          position: new google.maps.LatLng(marker.lat, marker.lng)
          map: window.map
          title: marker.title
          icon: (pins[marker.pin_id].image if pins[marker.pin_id])

        google.maps.event.addListener gMarker, 'click', () ->
          if gMarker.infoWindow
            gMarker.infoWindow.open(window.map, gMarker)
          else
            $.get $mapElement.data('info-window'), { node_id: gMarker.id.replace('marker-', '') },  (infoWindow) ->
              gMarker.infoWindow = new google.maps.InfoWindow()
              gMarker.infoWindow.setOptions { content: infoWindow }
              gMarker.infoWindow.open window.map, gMarker

        window.markers[id] = gMarker

    $mapElement.trigger 'markers-loaded'

$.fn.googlemap = () ->
  this.each ->
    $mapElement = $(this)
    element = $mapElement.get(0)

    $.get $mapElement.data('map'), (map) ->
      zoomLevel = map.zoom || 7
      bounds  = map.bounds

      if map.size
        [width, height] = map.size.split('x')
        $mapElement.css({width: Number(width), height: Number(height), background: '#fff'})

      wrapperElem = $mapElement.wrap('<div class="map-wrap"/>').css({background:'#fff'})

      mapOptions =
        mapTypeControl: true
        overviewMapControl: false
        scrollwheel: false
        mapTypeId: google.maps.MapTypeId.ROADMAP
        zoom: zoomLevel
        zoomControlOptions:
          style:google.maps.ZoomControlStyle.SMALL

      window.map = new google.maps.Map(element, mapOptions)
      window.map.fitBounds(new google.maps.LatLngBounds(new google.maps.LatLng(bounds[0][0], bounds[0][1]), new google.maps.LatLng(bounds[1][0], bounds[1][1]))) if bounds && bounds.length > 0
      google.maps.event.addListener(window.map, 'idle', -> showMarkers($mapElement) );

$ -> $('div[data-map]').googlemap()
