import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="maskcpfcnpj"
export default class extends Controller {
  static targets = ['inputCpfCnpj']

  connect() {}

  addMaskToCpfCnpjFields() {
    const input_cpfcnpj = this.inputCpfCnpjTarget.value
    const value_cpfcnpj = input_cpfcnpj.replace(/\D/g, '')
    let mask

    if (value_cpfcnpj.length <= 11) {
      mask = value_cpfcnpj
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d{1,2})$/, '$1-$2')
    } else {
      mask = value_cpfcnpj
        .replace(/(\d{2})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d)/, '$1/$2')
        .replace(/(\d{4})(\d)/, '$1-$2')
    }

    if (mask.length > 18) {
      // Atualiza o valor do input para o último estado válido
      this.inputCpfCnpjTarget.value = mask.slice(0, 18)
    } else {
      this.inputCpfCnpjTarget.value = mask
    }
  }
}
