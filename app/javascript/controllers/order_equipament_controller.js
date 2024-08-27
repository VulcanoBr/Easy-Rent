import { Application } from '@hotwired/stimulus'
import { Autocomplete } from 'stimulus-autocomplete'

const application = Application.start()

class OrderEquipamentController extends Autocomplete {
  static targets = [
    'periodStart',
    'periodEnd',
    'rentValue',
    'rentValueDisplay',
    'input',
    'hidden',
    'results',
    'totalValue',
    'totalValueDisplay',
    'paymentOptions',
    'pixFields',
    'boletoFields',
    'pixTotalValue',
    'boletoTotalValue'
  ]
  // static plugins = [Autocomplete]

  connect() {
    super.connect()
    this.checkPaymentOptions()
    console.log('aqui no connect')
    console.log('Has periodStart target:', this.hasPeriodStartTarget)
    console.log('Has periodEnd target:', this.hasPeriodEndTarget)
    console.log('Has rentValue target:', this.hasRentValueTarget)
    console.log('Has totalValue target:', this.hasTotalValueTarget)
    this.element.addEventListener(
      'autocomplete.change',
      this.onAutocompleteChange.bind(this)
    )
    if (this.hasPeriodStartTarget) {
      this.periodStartTarget.addEventListener(
        'change',
        this.calculateTotalRent.bind(this)
      )
    }
    if (this.hasPeriodEndTarget) {
      this.periodEndTarget.addEventListener(
        'change',
        this.calculateTotalRent.bind(this)
      )
    }
    this.pixCode = '1234567890123456789012345' // Código PIX fixo
    this.boletoCode = '1234567890123456789012' // Código Boleto fixo

    //  if (this.hasRentValueTarget && this.rentValueTarget.value) {
    //    this.formatRentValue(this.rentValueTarget.value)
    //  }
  }

  checkPaymentOptions() {
    const startDate = this.periodStartTarget.value
    const endDate = this.periodEndTarget.value
    const totalValue = parseFloat(this.totalValueTarget.value)

    if (startDate && endDate && totalValue > 0) {
      this.showPaymentOptions()
    } else {
      this.hidePaymentOptions()
    }
  }

  onAutocompleteChange(event) {
    console.log(`aqui change`)
    console.log('Autocomplete change event:', event)
    console.log('Event detail:', event.detail)

    const selectedItem = event.detail.selected
    console.log('Selected item:', selectedItem)

    if (selectedItem) {
      console.log('Selected item dataset:', selectedItem.dataset)
      const rentValue = selectedItem.dataset.rentValue
      console.log('Rent value:', rentValue)

      if (rentValue && this.hasRentValueTarget) {
        this.rentValueTarget.value = rentValue
        console.log('Rent value set to:', this.rentValueTarget.value)
        // this.formatValue(this.rentValueTarget)
        this.calculateTotalRent()
      } else {
        console.error('Rent value is undefined.')
      }
    } else {
      console.error('No item selected.')
    }
  }

  formatValue(element) {
    const numericValue = parseFloat(element.value)
    if (!isNaN(numericValue)) {
      element.dataset.unformattedValue = numericValue.toFixed(2)
      element.value = this.formatCurrency(numericValue)
    }
  }

  calculateTotalRent() {
    const totalValueElement = this.element.querySelector(
      '[data-order-equipament-target="totalValue"]'
    )
    if (!totalValueElement) {
      console.warn(
        'Total value element not found. Calculation will not be displayed.'
      )
      return
    }

    const startDate = this.hasPeriodStartTarget
      ? new Date(this.periodStartTarget.value)
      : null
    console.log('Date Start :', startDate)
    const endDate = this.hasPeriodEndTarget
      ? new Date(this.periodEndTarget.value)
      : null
    console.log('Date End :', endDate)
    const rentValue = this.hasRentValueTarget
      ? parseFloat(this.rentValueTarget.value)
      : 0
    console.log('Rent Value :', rentValue)
    // (startDate && endDate && !isNaN(rentValue))

    if (
      startDate &&
      endDate &&
      !isNaN(startDate.getTime()) &&
      !isNaN(endDate.getTime()) &&
      !isNaN(rentValue) &&
      startDate <= endDate
    ) {
      const diffTime = Math.abs(endDate - startDate)
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1 // +1 para incluir o último dia
      const totalRent = diffDays * rentValue

      totalValueElement.value = totalRent.toFixed(2)
      console.log('Total rent calculated:', totalRent.toFixed(2))
      //totalValueElement.dataset.unformattedValue = totalRent.toFixed(2)
      //totalValueElement.value = this.formatCurrency(totalRent)
      //this.totalValueTarget.dataset.unformattedValue = totalRent.toFixed(2)
      this.totalValueDisplayTarget.value = this.formatCurrency(totalRent)
      this.rentValueDisplayTarget.value = this.formatCurrency(rentValue)

      if (this.hasPixTotalValueTarget) {
        this.pixTotalValueTarget.value = this.formatCurrency(totalRent)
      }
      if (this.hasBoletoTotalValueTarget) {
        this.boletoTotalValueTarget.value = this.formatCurrency(totalRent)
      }

      this.showPaymentOptions()
    } else {
      this.zeroOutValues()
      //  totalValueElement.value = '0.00'
      console.log('Unable to calculate total rent: missing or invalid data')

      // Formatar o valor zero para o formato brasileiro
      //  const zeroFormatted = this.formatCurrency(0)
      //  this.totalValueDisplayTarget.value = zeroFormatted

      // Zerar também os campos de PIX e Boleto
      //  if (this.hasPixTotalValueTarget) {
      //    this.pixTotalValueTarget.value = zeroFormatted
      //  }
      //  if (this.hasBoletoTotalValueTarget) {
      //    this.boletoTotalValueTarget.value = zeroFormatted
      //  }
      //  console.log('Unable to calculate total rent: missing or invalid data')
      //  this.hidePaymentOptions()
    }
  }

  zeroOutValues() {
    const zeroFormatted = this.formatCurrency(0)

    if (this.hasTotalValueTarget) {
      this.totalValueTarget.value = '0.00'
    }

    if (this.hasTotalValueDisplayTarget) {
      this.totalValueDisplayTarget.value = zeroFormatted
    }

    if (this.hasRentValueDisplayTarget) {
      this.rentValueDisplayTarget.value = zeroFormatted
    }

    if (this.hasPixTotalValueTarget) {
      this.pixTotalValueTarget.value = zeroFormatted
    }

    if (this.hasBoletoTotalValueTarget) {
      this.boletoTotalValueTarget.value = zeroFormatted
    }

    console.log('Values zeroed out due to invalid or missing data')
    this.hidePaymentOptions()
  }

  formatCurrency(value) {
    return value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
  }

  showPaymentOptions() {
    //if (this.hasPaymentOptionsTarget) {
    this.paymentOptionsTarget.classList.remove('d-none')
    const paymentMethod = document.querySelector(
      'input[name="order[payment_method]"]:checked'
    )?.value
    const totalValue = this.totalValueTarget.value
    const formattedValue = this.formatCurrency(parseFloat(totalValue))
    if (paymentMethod === 'pix') {
      this.pixFieldsTarget.classList.remove('d-none')
      this.pixTotalValueTarget.value = formattedValue
    } else if (paymentMethod === 'boleto') {
      this.boletoFieldsTarget.classList.remove('d-none')
      this.boletoTotalValueTarget.value = formattedValue
    }
    //}
  }

  hidePaymentOptions() {
    // if (this.hasPaymentOptionsTarget) {
    this.paymentOptionsTarget.classList.add('d-none')
    // }
  }

  onPaymentMethodChange(event) {
    const method = event.target.value
    const totalValue = this.totalValueTarget.value
    const formattedValue = this.formatCurrency(parseFloat(totalValue))

    this.pixFieldsTarget.classList.add('d-none')
    this.boletoFieldsTarget.classList.add('d-none')

    if (method === 'pix') {
      this.pixFieldsTarget.classList.remove('d-none')
      this.pixTotalValueTarget.value = formattedValue
    } else if (method === 'boleto') {
      this.boletoFieldsTarget.classList.remove('d-none')
      this.boletoTotalValueTarget.value = formattedValue
    }
  }

  buildURL(query) {
    const periodStartValue = this.periodStartTarget.value
    const periodEndValue = this.periodEndTarget.value
    const urlBase = new URL(this.urlValue, window.location.href).toString()

    return `${urlBase}?q=${query}&period_start=${periodStartValue}&period_end=${periodEndValue}`
  }
}

export default OrderEquipamentController
