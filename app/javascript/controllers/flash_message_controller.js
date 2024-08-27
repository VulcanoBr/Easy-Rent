import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="flash-message"
export default class extends Controller {
  static targets = ['message']

  connect() {
    this.timeout = setTimeout(() => {
      this.hideMessage()
    }, 5000) // Hide the flash message after 5 seconds
  }

  hideMessage() {
    this.messageTarget.style.display = 'none'
  }

  removeMessage() {
    clearTimeout(this.timeout)
    this.hideMessage()
  }
}
