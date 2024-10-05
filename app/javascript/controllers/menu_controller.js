import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  // メニューの表示/非表示を切り替える
  toggleMenu(event) {
    // このイベントが親要素に伝播するのを防ぐ
    event.stopPropagation();
    this.sidebarTarget.classList.toggle('translate-x-full');
  }

  // サイドバーの×を押したらメニューを閉じる
  closeMenu() {
    this.sidebarTarget.classList.add('translate-x-full');
  }

  // メニュー以外の場所を押したら閉じる
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
