import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.initializeSelect2();
  }

  disconnect() {
    this.destroySelect2();
  }

  initializeSelect2() {
    $(this.element).find('.select2').each(function() {
      $(this).select2();
    });
  }

  destroySelect2() {
    $(this.element).find('.select2').each(function() {
      $(this).select2('destroy');
    });
  }
}
