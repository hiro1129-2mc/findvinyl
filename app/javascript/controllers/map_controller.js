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
    const infoWindow = new google.maps.InfoWindow();

    if (typeof window.shops !== 'undefined') {
      window.shops.forEach(shop => {
        const marker = new google.maps.Marker({
          position: { lat: parseFloat(shop.latitude), lng: parseFloat(shop.longitude) },
          map: this.map,
          title: shop.name,
          icon: image
        });

        const contentString = `
          <div id="content">
            ${shop.shop_image ? `<img src="${shop.shop_image}" alt="${shop.name}" class="w-96 h-48 mb-4 block rounded-md mx-auto">` : ''}
            <h2 class="text-xl mb-2 text-gray-800">${shop.name}</h2>
            <div id="bodyContent" class="text-gray-800 mb-2">
              <p>〒 ${shop.postal_code}</P>
              <p>${shop.address}</p>
            </div>
          </div>
        `;

        marker.addListener('click', () => {
          infoWindow.setContent(contentString);
          infoWindow.open({
            anchor: marker,
            map: this.map,
          });
        });
      });
    }
  }
}
