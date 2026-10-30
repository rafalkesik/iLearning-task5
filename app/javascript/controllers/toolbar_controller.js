import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toolbar"
export default class extends Controller {
  static targets = ["output"]

  generateSeed() {
    this.outputTarget.value = Math.floor(Math.random() * 100_000_000)
  }
}
