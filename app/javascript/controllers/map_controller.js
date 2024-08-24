import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map", "searchField"]

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
    const bounds = new google.maps.LatLngBounds();

    if (typeof window.shops !== 'undefined') {
      window.shops.forEach(shop => {
        const position = { lat: parseFloat(shop.latitude), lng: parseFloat(shop.longitude) };
        const marker = new google.maps.Marker({
          position: { lat: parseFloat(shop.latitude), lng: parseFloat(shop.longitude) },
          map: this.map,
          title: shop.name,
          icon: window.isSearchPerformed ? null : image
        });

        bounds.extend(position);

        marker.addListener('click', () => {
          this.fetchShopImage(shop.shop_image)
            .then(imageUrl => {
              const contentString = `
                <div id="content">
                  <img src="${imageUrl}" class="object-cover aspect-[16/9] max-w-[400px] max-h-[200px] mx-auto mb-2">
                  <h2 class="text-xl mb-2 text-gray-800">${shop.name}</h2>
                  <div id="bodyContent" class="text-gray-800 mb-2">
                    <p>〒 ${shop.postal_code}</p>
                    <p>${shop.address}</p>
                  </div>
                </div>
              `;
              infoWindow.setContent(contentString);
              infoWindow.open({
                anchor: marker,
                map: this.map,
              });
            })
            .catch(error => console.error('Error fetching shop image:', error));
        });
      });
      if (window.shops.length === 1) {
        this.map.setCenter(bounds.getCenter());
        this.map.setZoom(16);
      } else {
        this.map.fitBounds(bounds);
      }
    }
  }

  resetSearch() {
    this.searchFieldTarget.value = "";
    window.isSearchPerformed = false;
    window.shops = JSON.parse(sessionStorage.getItem('originalShops'));
    this.initMap();
  }

  async fetchShopImage(photoReference) {
    const proxyUrl = '/shops/image';
    const response = await fetch(`${proxyUrl}?photo_reference=${photoReference}`);
    if (!response.ok) {
      throw new Error('Failed to fetch shop image');
    }
    const data = await response.json();
    return data.imageUrl;
  }
}
