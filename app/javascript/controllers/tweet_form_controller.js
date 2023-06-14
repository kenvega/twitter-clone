import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tweet-form"
export default class extends Controller {
  connect() {
    this.element.addEventListener('turbo:submit-end', () => {
      // close the modal and clear the form for new tweets
      // document.getElementById('close-modal-btn').click();

      // click close on all modals with that class
      Array.from(document.getElementsByClassName('close-modal-btn')).forEach((btn) => { btn.click() })
      this.element.reset();
    })
  }
}
