import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "panel", "grid", "count"]

  connect() {
    this.files = []
    this.objectUrls = []
  }

  disconnect() {
    this.revokeObjectUrls()
  }

  preview() {
    const selectedFiles = Array.from(this.inputTarget.files || [])
    this.addFiles(selectedFiles)
    this.syncInputFiles()
    this.render()
  }

  remove(event) {
    const index = Number(event.currentTarget.dataset.index)
    this.files.splice(index, 1)
    this.syncInputFiles()
    this.render()
  }

  addFiles(files) {
    const imageFiles = files.filter((file) => file.type.startsWith("image/"))

    imageFiles.forEach((file) => {
      const alreadyAdded = this.files.some((existing) =>
        existing.name === file.name &&
        existing.size === file.size &&
        existing.lastModified === file.lastModified
      )

      if (!alreadyAdded && this.files.length < 20) {
        this.files.push(file)
      }
    })
  }

  syncInputFiles() {
    const transfer = new DataTransfer()
    this.files.forEach((file) => transfer.items.add(file))
    this.inputTarget.files = transfer.files
  }

  render() {
    this.revokeObjectUrls()
    this.gridTarget.innerHTML = ""
    this.panelTarget.hidden = this.files.length === 0
    this.countTarget.textContent = `${this.files.length}개`

    this.files.forEach((file, index) => {
      const url = URL.createObjectURL(file)
      this.objectUrls.push(url)

      const item = document.createElement("figure")
      item.className = "anacon-upload-preview-item"

      const image = document.createElement("img")
      image.src = url
      image.alt = file.name

      const removeButton = document.createElement("button")
      removeButton.type = "button"
      removeButton.className = "anacon-upload-preview-remove"
      removeButton.dataset.action = "anacon-preview#remove"
      removeButton.dataset.index = index
      removeButton.setAttribute("aria-label", `${file.name} 제거`)
      removeButton.textContent = "×"

      const caption = document.createElement("figcaption")
      caption.textContent = `${index + 1}. ${file.name}`

      item.append(image, removeButton, caption)
      this.gridTarget.append(item)
    })
  }

  revokeObjectUrls() {
    this.objectUrls?.forEach((url) => URL.revokeObjectURL(url))
    this.objectUrls = []
  }
}
