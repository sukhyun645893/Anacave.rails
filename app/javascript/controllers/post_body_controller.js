import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("img").forEach((image) => {
      if (image.complete && image.naturalWidth === 0) {
        this.replaceBrokenImage(image)
      } else {
        image.addEventListener("error", () => this.replaceBrokenImage(image), { once: true })
      }
    })
  }

  replaceBrokenImage(image) {
    if (image.dataset.brokenHandled === "true") return

    image.dataset.brokenHandled = "true"

    const placeholder = document.createElement("div")
    placeholder.className = "missing-post-image"
    placeholder.textContent = "\uC774\uBBF8\uC9C0\uB97C \uBD88\uB7EC\uC62C \uC218 \uC5C6\uC2B5\uB2C8\uB2E4. \uC608\uC804 \uC800\uC7A5\uC18C \uD30C\uC77C\uC774 \uB9CC\uB8CC\uB418\uC5C8\uC744 \uC218 \uC788\uC5B4\uC694. \uAE00\uC744 \uC218\uC815\uD574\uC11C \uB2E4\uC2DC \uC62C\uB824\uC8FC\uC138\uC694."

    image.replaceWith(placeholder)
  }
}
