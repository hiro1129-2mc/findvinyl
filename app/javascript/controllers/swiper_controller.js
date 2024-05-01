import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.swiper = new Swiper('.swiper', {
      loop: true,
      speed: 6000,
      autoplay: {
        delay: 0,
      },
    });
  }
}