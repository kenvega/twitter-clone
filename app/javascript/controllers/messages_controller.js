import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ['channel']

  headers = { 'Accept': 'text/vnd.turbo-stream.html' }

  connect() {
    // this.channelTargets represent each channel in the messages page. this is thanks to data-messages-target="channel" on app/views/channels/index.html.erb
    this.channelTargets.forEach((channel) => {
      channel.addEventListener('click', (e) => {
        e.preventDefault();

        this.channelTargets.forEach(channel => {
          channel.classList.remove('active')
        })

        channel.classList.add('active')

        if (!channel.dataset.channelId) return

        fetch(`messages/${channel.dataset.channelId}/messages?receiever_user_id=${channel.dataset.messagesTargetUserId}`, { headers: this.headers })
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
