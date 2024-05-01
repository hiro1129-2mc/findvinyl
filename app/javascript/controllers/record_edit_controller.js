import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "resultsContainer", "selectedItems", "form"]

  connect() {
    this.resultsContainerTarget.style.display = 'none'
    this.displayExistingItems()
    this.searchInputTarget.addEventListener('keypress', this.handleKeypress.bind(this))
    this.searchInputTarget.addEventListener('input', this.handleInput.bind(this))
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

  displayExistingItems() {
    if (gon.record_items) {
      gon.record_items.forEach((item) => {
        this.addItemToSelectedItems(item)
      })
    }
  }

  addItemToSelectedItems(item) {
    if (!this.formTarget.querySelector(`input[name="item_ids[]"][value="${item.id}"]`)) {
      const selectedItem = document.createElement('div')
      selectedItem.className = 'flex items-center py-1 text-accent justify-between w-full mb-1'
  
      let title = item.title.length > 10 ? `${item.title.substring(0, 10)}...　` : item.title
      let artistName = item.artist_name.length > 8 ? `${item.artist_name.substring(0, 8)}...` : item.artist_name
  
      const actualTitleLength = title.length > 10 ? 14 : title.length + 1
      const spaceToAdd = 13 - actualTitleLength
      let spaces = ''
      if (spaceToAdd > 0) {
        spaces = '　'.repeat(spaceToAdd)
      }
  
      const itemText = document.createTextNode(`♪ ${title}${spaces}${artistName}`)
      selectedItem.appendChild(itemText)
      this.selectedItemsTarget.appendChild(selectedItem)

      const removeButton = document.createElement('button')
      removeButton.innerHTML = '<span class="i-bi-x-lg bg-accent w-4 h-4 mr-4" aria-hidden="true"></span>'
      removeButton.onclick = () => this.removeItem(item, selectedItem)
      selectedItem.appendChild(removeButton)

      const hiddenInput = document.createElement('input')
      hiddenInput.setAttribute('type', 'hidden')
      hiddenInput.setAttribute('name', 'item_ids[]')
      hiddenInput.value = item.id
      this.formTarget.appendChild(hiddenInput)
    }
  }

  removeItem(item, selectedItem) {
    selectedItem.remove()
    this.formTarget.querySelector(`input[name="item_ids[]"][value="${item.id}"]`)?.remove()
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
          itemContainer.className = 'mb-2 flex justify-between items-center'

          let title = item.title.name.length > 10 ? `${item.title.name.substring(0, 10)}...　` : item.title.name
          let artistName = item.artist_name.name.length > 8 ? `${item.artist_name.name.substring(0, 8)}...` : item.artist_name.name

          const spaceToAdd = 12 - title.length
          let spaces = ''
          if (spaceToAdd > 0) {
            spaces = '　'.repeat(spaceToAdd)
          }
          const combinedText = `${title}${spaces}${artistName}`

          const itemText = document.createTextNode(combinedText)
          itemContainer.appendChild(itemText)

          const addButton = document.createElement('button')
          addButton.setAttribute('type', 'button')
          addButton.innerHTML = '<span class="i-bi-plus-circle bg-base-100 w-4 h-4" aria-hidden="true"></span>'
          addButton.onclick = () => this.addItemToSelectedItems(item)

          addButton.onclick = () => {
            const selectedItemsContainer = document.getElementById('selected_items');
            const selectedItem = document.createElement('div');
            selectedItem.className = 'flex items-center py-1 text-accent justify-between w-full mb-1';

            let title = item.title.name.length > 10 ? item.title.name.substring(0, 10) + '...　' : item.title.name;
            let artistName = item.artist_name.name.length > 8 ? item.artist_name.name.substring(0, 8) + '...' : item.artist_name.name;

            const actualTitleLength = item.title.name.length > 10 ? 14 : title.length + 1;
            const spaceToAdd = 13 - actualTitleLength;
            let spaces = '';
            if (spaceToAdd > 0) {
              spaces = '　'.repeat(spaceToAdd);
            }

            selectedItem.textContent = `♪ ${title}${spaces}${artistName}`;
            selectedItemsContainer.appendChild(selectedItem);

            const removeButton = document.createElement('button');
            removeButton.innerHTML = '<span class="i-bi-x-lg bg-accent w-4 h-4 mr-4" aria-hidden="true"></span>';
            removeButton.onclick = function() {
              selectedItem.remove();
              
              const hiddenInputs = document.querySelectorAll('input[name="item_ids[]"]');
              for (let input of hiddenInputs) {
                if (input.value === item.id.toString()) {
                  input.remove();
                  break;
                }
              }
            };
            selectedItem.appendChild(removeButton);

            selectedItemsContainer.appendChild(selectedItem);

            const hiddenInput = document.createElement('input');
            hiddenInput.setAttribute('type', 'hidden');
            hiddenInput.setAttribute('name', 'item_ids[]');
            hiddenInput.value = item.id;

            const form = document.getElementById('record_form');
            if (form) {
              form.appendChild(hiddenInput);
            }
          };

          itemContainer.appendChild(addButton);
          this.resultsContainerTarget.appendChild(itemContainer)
        })
      }).catch(error => {
        console.error('Error fetching items:', error)
        this.resultsContainerTarget.style.display = 'none'
      })
  }
}
