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

        fetch(`messages/${channel.dataset.channelId}/messages`, { headers: this.headers })
          .then(response => response.text())
          .then(html => Turbo.renderStreamMessage(html))
      })
    })
  }
}
