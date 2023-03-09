import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"
import jquery from "jquery"

// Connects to data-controller="toasts"
export default class extends Controller {
  connect() {
		jquery('.toast').each((_index, element) => new bootstrap.Toast(element).show())
  }
}
