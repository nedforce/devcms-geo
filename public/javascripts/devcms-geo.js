var originalMarkerImages = {};

document.observe('dom:loaded', function () {
  $$('.marker-link').each(function (link) {
    link.observe('click', function (event) {
      if (window.map) {
        Event.stop(event);
        marker = markers[link.id];

        // Reset other markers
        for (var key in markers) { 
          otherMarker = markers[key];
          if (originalMarkerImages[key] && otherMarker != marker) { otherMarker.setImage(originalMarkerImages[key]); }
        }

        if (!originalMarkerImages[link.id]) { originalMarkerImages[link.id] = marker.Zk.src; }
        marker.setImage("/pins/highlighted_pin?pin=" + encodeURIComponent(marker.Zk.src));
        GEvent.trigger(marker, 'click');
      }
    });
  });
});

function showAddress(address) {
  geocoder = new GClientGeocoder();
  geocoder.setViewport(map.getBounds());
  geocoder.getLocations(address, panAndZoomTo);
}

function panAndZoomTo(address) {
  ll = address.Placemark[0].Point.coordinates;
  ll = new GLatLng(ll[1], ll[0]);
  // Add marker on given location, remove the old one
  //if (mapCenterMarker) { map.removeOverlay(mapCenterMarker); }
  //mapCenterMarker = new GMarker(ll);
  //map.addOverlay(mapCenterMarker);
  //mapCenterMarker.setImage("/images/icons/red-pushpin.png");
  bounds = address.Placemark[0].ExtendedData.LatLonBox;
  bounds = new GLatLngBounds(new GLatLng(bounds.south, bounds.west), new GLatLng(bounds.north, bounds.east));
  zoom_target = map.getBoundsZoomLevel(bounds);
  current_zoom = map.getZoom();
  centered = false;

  if (current_zoom < zoom_target) {
    while (current_zoom < zoom_target) {
      map.zoomIn(ll, true, true);
      current_zoom += 1;
    }
  } else if (current_zoom === zoom_target) {
    map.panTo(ll);
  } else {
    while (current_zoom > zoom_target) {
      map.zoomOut(ll, true);
      current_zoom -= 1;
    }
  }
}
