import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ['messageThread']

  headers = { 'Accept': 'text/vnd.turbo-stream.html' }

  connect() {
    this.messageThreadTargets.forEach((messageThread) => {
      messageThread.addEventListener('click', e => {
        e.preventDefault()

        this.messageThreadTargets.forEach((messageThread) => {
          messageThread.classList.remove('active')
        })

        messageThread.classList.add('active')

        fetch(`/messages/${messageThread.dataset.messageThreadId}/messages?other_user_id=${messageThread.dataset.messagesTargetUserId}`, { headers: this.headers })
          .then(response => response.text())
          .then(html => Turbo.renderStreamMessage(html))
      })
    })

    const queryString = window.location.search
    const urlParams = new URLSearchParams(queryString)

    if (urlParams.get('user_id') !== null) {
      this.element.querySelector(`[data-messages-target-user-id="${urlParams.get('user_id')}"]`).click()
      this.element.querySelector(`[data-messages-target-user-id="${urlParams.get('user_id')}"]`).classList.add('active')
    }
  }
}
