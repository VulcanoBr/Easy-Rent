import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['menu']

  connect() {
    console.log('aqui no tooggle')
    this.toggleClass = 'show'
  }

  toggle(event) {
    console.log('aqui no tooggle 2')
    event.preventDefault()
    this.menuTarget.classList.toggle(this.toggleClass)
  }

  hide(event) {
    console.log('aqui no tooggle 3')
    if (this.element.contains(event.target) === false) {
      console.log('aqui no tooggle false')
      this.menuTarget.classList.remove(this.toggleClass)
    }
  }
}
