import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initMap();
  }

  async initMap() {
    const { Map } = await google.maps.importLibrary("maps");

    this.map = new Map(this.element.querySelector('#map'), {
      center: { lat: 35.6811673, lng: 139.7670516 },
      zoom: 15,
    });
  }
}
