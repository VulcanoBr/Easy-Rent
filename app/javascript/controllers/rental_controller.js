import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="test"
export default class extends Controller {
  static targets = [
    'startDate',
    'endDate',
    'rentValue',
    'totalValue',
    'totalValueDisplay',
    'paymentOptions'
  ]

  connect() {
    this.calculateTotal()
    this.showPaymentOptions()
  }

  calculateTotal() {
    const startDate = new Date(this.startDateTarget.value)
    const endDate = new Date(this.endDateTarget.value)
    const rentValue = parseFloat(this.rentValueTarget.value)

    if (!isNaN(startDate) && !isNaN(endDate) && startDate <= endDate) {
      const diffTime = Math.abs(endDate - startDate)
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1 // Include start and end date
      const totalValue = diffDays * rentValue
      const formattedTotalValue = totalValue.toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL'
      })
      this.totalValueDisplayTarget.value = formattedTotalValue
      // Armazenar o valor real
      this.totalValueTarget.value = totalValue.toFixed(2)

      // Emit a custom event with the total value
      this.dispatch('totalCalculated', { detail: { totalValue } })
    } else {
      this.totalValueDisplayTarget.value = 'R$ 0,00'
      this.totalValueTarget.value = 0
    }
  }

  showPaymentOptions() {
    const endDateValue = this.endDateTarget.value
    if (endDateValue && this.hasPaymentOptionsTarget) {
      this.paymentOptionsTarget.classList.remove('d-none')

      this.dispatch('change')
      // this.creditCardFieldsTarget.classList.remove('d-none')
      //  this.dispatch('change')
    } else {
      this.paymentOptionsTarget.classList.add('d-none')
    }
  }
}
