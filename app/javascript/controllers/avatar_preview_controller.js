import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "input"]

  connect() {
    this.previewTarget.style.width = "120px"
    this.previewTarget.style.height = "120px"
    this.previewTarget.style.objectFit = "cover"
    this.previewTarget.style.objectPosition = "center"
  }

  preview(event) {
    const file = this.inputTarget.files[0]
    const reader = new FileReader()

    reader.onloadend = () => {
      this.previewTarget.src = reader.result
    }

    if (file) {
      reader.readAsDataURL(file)
    } else {
      this.previewTarget.src = ""
    }
  }
}
