import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof google !== 'undefined') {
      this.initMap();
    } else {
      console.error("Google Maps API is not loaded.");
    }
  }

  initMap() {
    const shopLocation = { 
      lat: parseFloat(this.mapTarget.dataset.latitude), 
      lng: parseFloat(this.mapTarget.dataset.longitude) 
    };

    const map = new google.maps.Map(this.mapTarget, {
      zoom: 15,
      center: shopLocation,
    });

    new google.maps.Marker({
      position: shopLocation,
      map: map,
      title: this.mapTarget.dataset.name
    });
  }
}
