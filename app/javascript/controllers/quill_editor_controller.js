import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "input"]
  static values = { content: String }

  connect() {
    if (!window.Quill) {
      this.editorTarget.innerHTML = "에디터를 불러오지 못했습니다. 인터넷 연결을 확인해주세요."
      return
    }

    this.quill = new window.Quill(this.editorTarget, {
      modules: {
        toolbar: {
          container: [
            [{ header: [1, 2, 3, false] }],
            ["bold", "italic", "underline", "strike"],
            [{ color: [] }, { background: [] }],
            [{ list: "ordered" }, { list: "bullet" }],
            [{ align: [] }],
            ["blockquote", "code-block"],
            ["link", "image"],
            ["clean"]
          ],
          handlers: {
            image: () => this.insertImage()
          }
        }
      },
      placeholder: "내용을 입력하세요.",
      theme: "snow"
    })

    if (this.contentValue) {
      this.quill.clipboard.dangerouslyPasteHTML(this.contentValue)
    }

    this.syncInput()
    this.quill.on("text-change", () => this.syncInput())
    this.element.closest("form")?.addEventListener("submit", () => this.syncInput())
  }

  insertAnacon(event) {
    const url = event.currentTarget.dataset.anaconUrl
    if (!url || !this.quill) return

    const range = this.quill.getSelection(true)
    this.quill.insertEmbed(range.index, "image", url)
    this.quill.insertText(range.index + 1, " ")
    this.quill.setSelection(range.index + 2)
    this.syncInput()
  }

  insertImage() {
    const fileInput = document.createElement("input")
    fileInput.setAttribute("type", "file")
    fileInput.setAttribute("accept", "image/png,image/jpeg,image/gif,image/webp")
    fileInput.click()

    fileInput.addEventListener("change", async () => {
      const file = fileInput.files?.[0]
      if (!file) return

      const formData = new FormData()
      formData.append("image", file)

      const response = await fetch("/uploads", {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: formData
      })

      if (!response.ok) {
        window.alert("이미지 업로드에 실패했습니다.")
        return
      }

      const { url } = await response.json()
      const range = this.quill.getSelection(true)
      this.quill.insertEmbed(range.index, "image", url)
      this.quill.setSelection(range.index + 1)
      this.syncInput()
    })
  }

  syncInput() {
    this.inputTarget.value = this.quill.root.innerHTML
  }
}
