import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    $(this.element).find('.select2').select2();
  }

  disconnect() {
    $(this.element).find('.select2').select2('destroy');
  }
}
