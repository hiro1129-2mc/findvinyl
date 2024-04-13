import { Controller } from "stimulus";
import Swiper from 'swiper';
import 'swiper/css';

export default class extends Controller {
  static values = {
    index: Number
  }

  initialize() {
    this.swiper = null;
  }

  connect() {
    if (!this.hasSwiper) {
      this.initSwiper();
    }
  }

  disconnect() {
    this.swiper.destroy();
    this.swiper = null;
  }

  initSwiper() {
    this.swiper = new Swiper(this.element, {
      loop: true,
      effect: 'slide',
      speed: 3000,
      autoplay: {
        delay: 3000,
        disableOnInteraction: false
      },
      pagination: {
        el: '.swiper-pagination',
        type: 'bullets',
        clickable: true
      },
    });
    this.hasSwiper = true;
  }
}
