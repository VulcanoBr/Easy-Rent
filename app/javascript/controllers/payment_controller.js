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
    console.log('payment controller ')
    // document.addEventListener('DOMContentLoaded', () => {
    this.togglePaymentFieldsOnLoad()
    // })
    //this.togglePaymentFieldsOnLoad()
  }

  togglePaymentFields(event) {
    const paymentMethod = event
      ? event.target.value
      : this.currentPaymentMethod()

    console.log(`Título: ${paymentMethod}`)
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
    console.log('aqui no calculo em apyment')
    const totalValue = event.detail.totalValue
    this.data.set('totalValue', totalValue) // Store the total value

    // Update total value fields if payment method is selected
    this.togglePaymentFields()
  }

  togglePaymentFieldsOnLoad() {
    console.log('aqui no onLoad')
    const paymentMethod = this.currentPaymentMethod()
    console.log(`OnLoad: ${paymentMethod}`)

    if (paymentMethod === 'cartao') {
      // || paymentMethod == undefined) {
      this.creditCardFieldsTarget.classList.remove('d-none')
    }
    if (paymentMethod) {
      this.togglePaymentFields()
      // this.togglePaymentFields({ target: { value: paymentMethod } })
    }
    // if (paymentMethod === 'cartao') {
    //   console.log('aqui no metodo cartão')
    //   this.creditCardFieldsTarget.classList.remove('d-none')
    // }
  }

  currentPaymentMethod() {
    console.log(
      `current : ${document.querySelector(
        'input[name="order[payment_method]"]:checked'
      )}`
    )
    return document.querySelector('input[name="order[payment_method]"]:checked')
      ?.value
  }

  /* togglePaymentFields(event) {
    console.log('payment event ')
    const paymentMethod = event
      ? event.target.value
      : this.currentPaymentMethod()

    if (this.hasCreditCardFieldsTarget) {
      this.creditCardFieldsTarget.classList.add('d-none')
    }
    if (this.hasPixFieldsTarget) {
      this.pixFieldsTarget.classList.add('d-none')
    }
    if (this.hasBoletoFieldsTarget) {
      this.boletoFieldsTarget.classList.add('d-none')
    }
    switch (paymentMethod) {
      case 'cartao':
        this.creditCardFieldsTarget.classList.remove('d-none')
        break
      case 'pix':
        this.pixFieldsTarget.classList.remove('d-none')
        this.loadPixData()
        break
      case 'boleto':
        this.boletoFieldsTarget.classList.remove('d-none')
        this.loadBoletoData()
        break
    }
  }

  loadPixData() {
    const totalRentValue = document.querySelector(
      'input[name="tot_rent_value"]'
    ).value
    document.querySelector('input[name="pix_amount"]').value = totalRentValue
    document.querySelector('input[name="pix_code"]').value =
      this.generateRandomCode(15)
  }

  loadBoletoData() {
    const totalRentValue = document.querySelector(
      'input[name="tot_rent_value"]'
    ).value
    document.querySelector('input[name="boleto_amount"]').value = totalRentValue
    document.querySelector('input[name="boleto_code"]').value =
      this.generateRandomCode(20)
  }

  generateRandomCode(length) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    let code = ''
    for (let i = 0; i < length; i++) {
      const randomIndex = Math.floor(Math.random() * chars.length)
      code += chars[randomIndex]
    }
    return code
  }

  currentPaymentMethod() {
    return document.querySelector(
      'input[name="payment[payment_method]"]:checked'
    )?.value
  } */
}
