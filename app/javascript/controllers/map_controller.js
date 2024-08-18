import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (window.google && window.google.maps) {
      this.initMap();
    } else {
      window.initMap = this.initMap.bind(this);
    }
  }

  initMap() {
    const mapOptions = {
      center: { lat: 35.6811673, lng: 139.7670516 },
      zoom: 15,
    };

    this.map = new google.maps.Map(this.mapTarget, mapOptions);
    this.addMarkers();
  }

  addMarkers() {
    const image = '/img/marker.png';
    if (typeof window.shops !== 'undefined') {
      window.shops.forEach(shop => {
        new google.maps.Marker({
          position: { lat: parseFloat(shop.latitude), lng: parseFloat(shop.longitude) },
          map: this.map,
          title: shop.name,
          icon: image
        });
      });
    }
  }
}
