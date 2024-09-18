import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "prevButton", "nextButton"]

  connect() {
    this.showSlide('slide1')
  }

  showSlide(slideId) {
    this.slideTargets.forEach(slide => {
      slide.style.display = slide.id === slideId ? 'block' : 'none'
    })
  }

  handleNavClick(event) {
    event.preventDefault()
    const targetSlideId = event.currentTarget.getAttribute('href').substring(1)
    this.showSlide(targetSlideId)
  }

  prev(event) {
    this.handleNavClick(event)
  }

  next(event) {
    this.handleNavClick(event)
  }
}
