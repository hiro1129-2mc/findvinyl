import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "field" ]

  connect() {
    this.setupValidation()
    this.element.removeEventListener('submit', this.handleSubmit)
    this.element.addEventListener('submit', this.handleSubmit.bind(this))
  }

  // フィールドの文字数が最大文字数を超えているかチェックする
  checkFieldValidity(field) {
    const maxLength = parseInt(field.dataset.maxLength)
    if (field.value.length > maxLength) {
      return `${maxLength}文字以内で入力してください`
    }
    return ''
  }

  // ターゲットのフィールドに入力されたフィールドの文字数が最大文字数を超えた場合エラーメッセージを表示
  setupValidation() {
    this.fieldTargets.forEach(field => {
      let errorSpan = field.nextElementSibling
      if (!errorSpan || !errorSpan.classList.contains('error-message')) {
        errorSpan = document.createElement('span')
        errorSpan.classList.add('error-message', 'text-primary', 'text-sm', 'mt-1')
        field.parentNode.insertBefore(errorSpan, field.nextSibling)
      }
      
      field.addEventListener('input', () => {
        const errorMessage = this.checkFieldValidity(field)
        errorSpan.textContent = errorMessage
      })
    })
  }

  // フィールドの文字数が最大文字数を超えている場合バリデーションメッセージを表示
  handleSubmit(event) {
    let isValid = true
    this.fieldTargets.forEach(field => {
      const errorMessage = this.checkFieldValidity(field)
      if (errorMessage) {
        isValid = false
        field.setCustomValidity(errorMessage)
      } else {
        field.setCustomValidity('')
      }
    })

    // バリデーションに引っかかった場合フォームの送信を防ぐ
    if (!isValid) {
      event.preventDefault()
      this.element.reportValidity()
    }
  }
}
