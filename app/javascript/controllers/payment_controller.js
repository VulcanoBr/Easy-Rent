import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = [
    'creditCardFields',
    'pixFields',
    'boletoFields',
    'pixTotalValue',
    'boletoTotalValue',
    'installments',
    'paymentOptions'
  ]

  connect() {
    this.togglePaymentFieldsOnLoad()
  }

  togglePaymentFields(event) {
    const paymentMethod = event
      ? event.target.value
      : this.currentPaymentMethod()

    this.creditCardFieldsTarget.classList.toggle(
      'd-none',
      paymentMethod !== 'cartao'
    )
    this.pixFieldsTarget.classList.toggle('d-none', paymentMethod !== 'pix')
    this.boletoFieldsTarget.classList.toggle(
      'd-none',
      paymentMethod !== 'boleto'
    )

    this.updatePaymentTotal()
    this.updateInstallments()
  }

  updatePaymentTotal() {
    const totalValue = document.querySelector(
      '[data-rental-target="totalValue"]'
    ).value

    const formattedTotalValue = this.formatCurrencyBRL(totalValue)

    if (this.pixTotalValueTarget) {
      this.pixTotalValueTarget.value = formattedTotalValue
    }

    if (this.boletoTotalValueTarget) {
      this.boletoTotalValueTarget.value = formattedTotalValue
    }
  }

  formatCurrencyBRL(value) {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value)
  }

  updateInstallments() {
    const totalValue =
      parseFloat(
        document.querySelector('[data-rental-target="totalValue"]').value
      ) || 0
    const installmentsTarget = this.installmentsTarget

    while (installmentsTarget.options.length > 0) {
      installmentsTarget.remove(0)
    }

    for (let i = 1; i <= 12; i++) {
      const installmentValue = totalValue / i
      const formattedInstallmentValue = this.formatCurrencyBRL(installmentValue)
      const optionText = `${i} x de ${formattedInstallmentValue}`
      const option = new Option(optionText, i)
      installmentsTarget.add(option)
    }
  }

  // Listen to the custom event 'rental:totalCalculated'
  totalCalculated(event) {
    const totalValue = event.detail.totalValue
    this.data.set('totalValue', totalValue) // Store the total value

    // Update total value fields if payment method is selected
    this.togglePaymentFields()
  }

  togglePaymentFieldsOnLoad() {
    const paymentMethod = this.currentPaymentMethod()

    if (paymentMethod === 'cartao') {
      this.creditCardFieldsTarget.classList.remove('d-none')
    }
    if (paymentMethod) {
      this.togglePaymentFields()
    }
  }

  currentPaymentMethod() {
    return document.querySelector('input[name="order[payment_method]"]:checked')
      ?.value
  }
}
