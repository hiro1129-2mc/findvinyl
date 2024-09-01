import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "resultsContainer", "selectedItems", "form"]

  connect() {
    this.resultsContainerTarget.style.display = 'none'
    this.searchInputTarget.addEventListener('keypress', this.handleKeypress.bind(this))
    this.searchInputTarget.addEventListener('input', this.handleInput.bind(this))
    this.formTarget.addEventListener('submit', this.handleSubmit.bind(this))
  }

  handleKeypress(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
      this.fetchItems(this.searchInputTarget.value)
    }
  }

  handleInput(event) {
    const query = this.searchInputTarget.value.trim()
    if (query === '') {
      this.resultsContainerTarget.style.display = 'none'
    } else {
      this.fetchItems(query)
    }
  }

  search(event) {
    const query = this.searchInputTarget.value.trim()
    if (query === '') {
      this.resultsContainerTarget.style.display = 'none'
    } else {
      this.fetchItems(query)
    }
  }

  fetchItems(query) {
    fetch(`/records/search?q=${query}`)
      .then(response => response.json())
      .then(data => {
        this.resultsContainerTarget.innerHTML = ''

        if (data.length > 0) {
          this.resultsContainerTarget.style.display = ''
        } else {
          this.resultsContainerTarget.style.display = 'none'
          return
        }

        data.forEach(item => {
          const itemContainer = document.createElement('div')
          itemContainer.className = 'flex justify-between items-center py-1'

          const titleContainer = document.createElement('div')
          titleContainer.className = 'w-[200px]'

          const titleElement = document.createElement('p')
          titleElement.className = 'truncate'
          titleElement.textContent = item.title.name
          titleContainer.appendChild(titleElement)

          const artistContainer = document.createElement('div')
          artistContainer.className = 'w-[130px]'

          const artistElement = document.createElement('p')
          artistElement.className = 'truncate'
          artistElement.textContent = item.artist_name.name
          artistContainer.appendChild(artistElement)

          itemContainer.appendChild(titleContainer)
          itemContainer.appendChild(artistContainer)

          const addButton = document.createElement('button')
          addButton.setAttribute('type', 'button')
          addButton.innerHTML = '<span class="i-bi-plus-circle bg-base-100 w-4 h-4" aria-hidden="true"></span>'
          addButton.onclick = () => this.addItem(item)

          itemContainer.appendChild(addButton)
          this.resultsContainerTarget.appendChild(itemContainer)
        })
      })
      .catch(error => {
        console.error('Error fetching items:', error)
        this.resultsContainerTarget.style.display = 'none'
      })
  }

  addItem(item) {
    const selectedItem = document.createElement('div')
    selectedItem.className = 'flex items-center py-1 justify-between w-full mb-1'
  
    const noteIcon = document.createElement('span')
    noteIcon.className = 'i-bi-music-note bg-primary w-4 h-4'
    noteIcon.setAttribute('aria-hidden', 'true')
    selectedItem.appendChild(noteIcon)
  
    const titleContainer = document.createElement('div')
    titleContainer.className = 'w-[200px]'
  
    const titleElement = document.createElement('p')
    titleElement.className = 'truncate'
    titleElement.textContent = item.title.name
    titleContainer.appendChild(titleElement)
  
    const artistContainer = document.createElement('div')
    artistContainer.className = 'w-[120px]'
  
    const artistElement = document.createElement('p')
    artistElement.className = 'truncate'
    artistElement.textContent = item.artist_name.name
    artistContainer.appendChild(artistElement)
  
    selectedItem.appendChild(titleContainer)
    selectedItem.appendChild(artistContainer)
  
    const removeButton = document.createElement('button')
    removeButton.innerHTML = '<span class="i-bi-x-lg bg-accent w-4 h-4 mr-4" aria-hidden="true"></span>'
    removeButton.onclick = () => this.removeItem(item, selectedItem)
    selectedItem.appendChild(removeButton)
  
    this.selectedItemsTarget.appendChild(selectedItem)
  
    const form = this.formTarget || document.getElementById('record_form')
    if (form) {
      const hiddenInput = document.createElement('input')
      hiddenInput.setAttribute('type', 'hidden')
      hiddenInput.setAttribute('name', 'item_ids[]')
      hiddenInput.value = item.id
      form.appendChild(hiddenInput)
    }
  }

  removeItem(item, selectedItem) {
    selectedItem.remove()

    const hiddenInputs = this.formTarget.querySelectorAll('input[name="item_ids[]"]')
    for (let input of hiddenInputs) {
      if (input.value === item.id.toString()) {
        input.remove()
        break
      }
    }
  }

  handleSubmit(event) {
    if (this.selectedItemsTarget.children.length === 0) {
      event.preventDefault()
      alert("レコードが選択されていません。")
    }
  }
}
