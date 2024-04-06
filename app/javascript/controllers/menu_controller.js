import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  toggleMenu(event) {
    event.stopPropagation(); // このイベントが親要素に伝播するのを防ぐ
    this.sidebarTarget.classList.toggle('translate-x-full');
  }

  closeMenu() {
    this.sidebarTarget.classList.add('translate-x-full');
  }

  // メニュー以外の場所をクリックしたら閉じる
  closeMenuOutside(event) {
    if (!this.element.contains(event.target)) {
      this.sidebarTarget.classList.add('translate-x-full');
    }
  }

  connect() {
    document.addEventListener('click', this.closeMenuOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener('click', this.closeMenuOutside.bind(this));
  }
}
