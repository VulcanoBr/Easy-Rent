import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['menu']

  connect() {
    this.toggleClass = 'show'
  }

  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle(this.toggleClass)
  }

  hide(event) {
    if (this.element.contains(event.target) === false) {
      this.menuTarget.classList.remove(this.toggleClass)
    }
  }
}
