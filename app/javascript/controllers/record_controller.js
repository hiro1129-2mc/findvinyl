import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "resultsContainer", "selectedItems", "form"]

  connect() {
    this.resultsContainerTarget.style.display = 'none'
    this.displayExistingItems()
    this.searchInputTarget.addEventListener('keypress', this.handleKeypress.bind(this))
    this.searchInputTarget.addEventListener('input', this.handleInput.bind(this))
    this.formTarget.addEventListener('submit', this.handleSubmit.bind(this))
  }

  // record編集フォームに既存のitemを表示
  displayExistingItems() {
    if (typeof gon !== 'undefined' && gon.record_items) {
      gon.record_items.forEach((item) => {
        this.addItemToSelectedItems(item)
      })
    }
  }

  // Enterキーが押された場合にrecordが保存されるのを防ぐ
  handleKeypress(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
    }
  }

  handleInput(event) {
    const query = this.searchInputTarget.value.trim()
    if (query === '') {
      // ユーザーが検索フォームを空にしたら検索結果を非表示にする
      this.resultsContainerTarget.style.display = 'none'
    } else {
      // 検索フォームに文字が入力されたらfetchItems(query)へ
      this.fetchItems(query)
    }
  }

  // 非同期でRecordsControllerのsearchアクションにリクエストを送り検索を実行
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
          const itemContainer = this.createSearchResultItemElement(item)
          this.resultsContainerTarget.appendChild(itemContainer)
        })
      })
      .catch(error => {
        console.error('Error fetching items:', error)
        this.resultsContainerTarget.style.display = 'none'
      })
  }

  // 検索結果のHTML要素を生成
  createSearchResultItemElement(item) {
    const itemContainer = document.createElement('div')
    itemContainer.className = 'flex justify-between items-center w-full py-1 mb-1'

    const titleContainer = document.createElement('div')
    titleContainer.className = 'w-[160px] md:w-[200px]'

    const titleElement = document.createElement('p')
    titleElement.className = 'truncate'
    titleElement.textContent = item.title.name
    titleContainer.appendChild(titleElement)

    const artistContainer = document.createElement('div')
    artistContainer.className = 'w-[100px] md:w-[130px]'

    const artistElement = document.createElement('p')
    artistElement.className = 'truncate'
    artistElement.textContent = item.artist_name.name
    artistContainer.appendChild(artistElement)

    itemContainer.appendChild(titleContainer)
    itemContainer.appendChild(artistContainer)

    // 検索結果をselectedItemsに追加するボタン
    const addButton = document.createElement('button')
    addButton.setAttribute('type', 'button')
    addButton.innerHTML = '<span class="i-bi-plus-circle bg-base-100 w-4 h-4" aria-hidden="true"></span>'
    addButton.onclick = () => this.addItemToSelectedItems(item)

    itemContainer.appendChild(addButton)
    return itemContainer
  }

  // 検索結果から選択したitemをselectedItemsに追加
  addItemToSelectedItems(item) {
    // 同じitemが保存されないようにする
    if (!this.formTarget.querySelector(`input[name="item_ids[]"][value="${item.id}"]`)) {
      const selectedItem = this.createSelectedItemElement(item)
      this.selectedItemsTarget.appendChild(selectedItem)

      // 選択したitemのIDをフォームデータとして送信する隠しフィールドを作成
      const hiddenInput = document.createElement('input')
      hiddenInput.setAttribute('type', 'hidden')
      hiddenInput.setAttribute('name', 'item_ids[]')
      hiddenInput.value = item.id
      this.formTarget.appendChild(hiddenInput)
    }
  }

  // 選択したitemのHTML要素を生成
  createSelectedItemElement(item) {
    const selectedItem = document.createElement('div')
    selectedItem.className = 'flex items-center py-1 justify-between w-full mb-1'
  
    const noteIcon = document.createElement('span')
    noteIcon.className = 'i-bi-music-note bg-primary w-4 h-4 flex-shrink-0'
    noteIcon.setAttribute('aria-hidden', 'true')
    selectedItem.appendChild(noteIcon)
  
    const titleContainer = document.createElement('div')
    titleContainer.className = 'w-[160px] md:w-[200px]'
  
    const titleElement = document.createElement('p')
    titleElement.className = 'truncate'
    titleElement.textContent = item.title.name || item.title
    titleContainer.appendChild(titleElement)
  
    const artistContainer = document.createElement('div')
    artistContainer.className = 'w-[90px] md:w-[120px]'
  
    const artistElement = document.createElement('p')
    artistElement.className = 'truncate'
    artistElement.textContent = item.artist_name.name || item.artist_name
    artistContainer.appendChild(artistElement)
  
    selectedItem.appendChild(titleContainer)
    selectedItem.appendChild(artistContainer)
  
    // 選択したselectedItemsを削除するボタン
    const removeButton = document.createElement('button')
    removeButton.innerHTML = '<span class="i-bi-x-lg bg-accent w-4 h-4 mr-4" aria-hidden="true"></span>'
    removeButton.onclick = () => this.removeItem(item, selectedItem)
    selectedItem.appendChild(removeButton)
  
    return selectedItem
  }

  // selectedItemsを削除
  removeItem(item, selectedItem) {
    selectedItem.remove()
    this.formTarget.querySelector(`input[name="item_ids[]"][value="${item.id}"]`)?.remove()
  }

  // selectedItemsが選択せれていない場合アラートを表示
  handleSubmit(event) {
    if (this.selectedItemsTarget.children.length === 0) {
      event.preventDefault()
      alert("レコードが選択されていません。")
    }
  }
}
