import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (window.google && window.google.maps) {
      this.initGeolocation();
    } else {
      window.initMap = this.initGeolocation.bind(this);
    }
  }

  // ユーザーの位置情報を取得
  initGeolocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        this.handleLocationSuccess.bind(this),
        this.handleLocationError.bind(this)
      );
    } else {
      this.initMap({ lat: 35.6811673, lng: 139.7670516 });
    }
  }

  // ユーザーの位置情報を取得できれば地図の中心に設定
  handleLocationSuccess(position) {
    const userLocation = {
      lat: position.coords.latitude,
      lng: position.coords.longitude
    };
    this.initMap(userLocation);
  }

  // 位置情報の取得に失敗した場合、中心を東京駅付近に設定
  handleLocationError(error) {
    console.warn(`ERROR(${error.code}): ${error.message}`);
    this.initMap({ lat: 35.6811673, lng: 139.7670516 });
  }

  // 地図を初期化
  initMap(center) {
    const mapOptions = {
      center: center,
      zoom: 15,
    };
    this.map = new google.maps.Map(this.mapTarget, mapOptions);
    this.addMarkers(center);
  }

  // ショップにマーカーと情報ウィンドウを追加
  addMarkers(center) {
    const image = '/img/marker.png';
    const infoWindow = new google.maps.InfoWindow();
    const bounds = new google.maps.LatLngBounds();
    let markersCount = 0;

    if (typeof window.shops !== 'undefined') {
      window.shops.forEach(shop => {
        const position = { lat: parseFloat(shop.latitude), lng: parseFloat(shop.longitude) };
        // 検索結果にはGoogleマップ標準のマーカーを表示
        const marker = new google.maps.Marker({
          position: position,
          map: this.map,
          title: shop.name,
          icon: window.isSearchPerformed ? null : image
        });

        bounds.extend(position);
        markersCount++;

        // マーカーを押すと情報ウィンドウが開く
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
                  <div class="link link-hover text-blue-600 mb-2">
                    <a href="/shops/${shop.id}">詳細を見る</a>
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

      // 検索が行われたか確認・検索結果の件数によって地図の中心とズームの設定を分岐
      if (window.isSearchPerformed) {
        if (markersCount === 1) {
          this.map.setCenter(bounds.getCenter());
          this.map.setZoom(16);
        } else if (markersCount > 1) {
          this.map.fitBounds(bounds);
        }
      } else {
        this.map.setCenter(center);
        this.map.setZoom(15);
      }
    }
  }

  // ショップ画像を非同期で取得
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
