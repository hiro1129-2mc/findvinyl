document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("item_search");
  const resultsContainer = document.getElementById("search_results");
  const selectedItemsContainer = document.getElementById('selected_items');
  const form = document.getElementById('record_form');

  // 初期状態では検索結果のコンテナを非表示に設定
  resultsContainer.style.display = 'none';

  // 既存のアイテムを表示
  const displayExistingItems = () => {
    if (gon.record_items) {
      gon.record_items.forEach((item) => {
        addItemToSelectedItems(item);
      });
    }
  };

  // 新しいアイテムをselectedItemsに追加する関数
  const addItemToSelectedItems = (item) => {
    const itemElement = document.createElement('div');
    itemElement.className = 'item';
    itemElement.style.display = 'flex';
    itemElement.style.justifyContent = 'space-between';
    itemElement.style.alignItems = 'center';

    const itemText = document.createElement('span');
    itemText.textContent = `\u3000${item.title} ${item.artist_name}`;
    itemElement.appendChild(itemText);

    const removeButton = document.createElement('button');
    removeButton.innerHTML = '&times;';
    removeButton.className = 'remove-button';
    removeButton.style.marginLeft = 'auto';
    removeButton.onclick = () => {
      itemElement.remove();
      // 選択されたアイテムのIDを保持する隠しフィールドも削除
      document.querySelector(`input[name="item_ids[]"][value="${item.id}"]`)?.remove();
    };

    itemElement.appendChild(removeButton);
    selectedItemsContainer.appendChild(itemElement);

    // 選択されたアイテムのIDを保持する隠しフィールドを追加
    const hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'item_ids[]');
    hiddenInput.value = item.id;
    form.appendChild(hiddenInput);
  };

  // アイテムを検索して結果を表示する関数
  function fetchItems(query) {
    fetch(`/records/search?q=${query}`)
      .then(response => response.json())
      .then(data => {
        resultsContainer.innerHTML = ''; // 検索結果をクリア

        // 検索結果がある場合のみコンテナを表示
        if (data.length > 0) {
          resultsContainer.style.display = '';
        } else {
          resultsContainer.style.display = 'none';
          return;
        }

        data.forEach(item => {
          const itemContainer = document.createElement('div');
          itemContainer.className = 'mb-2 flex justify-between items-center';

          const itemText = document.createTextNode(`${item.title.name} ${item.artist_name.name}`);
          itemContainer.appendChild(itemText);

          const addButton = document.createElement('button');
          addButton.setAttribute('type', 'button');
          addButton.textContent = '登録';
          addButton.className = 'ml-2 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700';
          addButton.onclick = () => {
            const selectedItemsContainer = document.getElementById('selected_items');
            const selectedItem = document.createElement('div');
            selectedItem.className = 'flex items-center mb-2 bg-white text-black rounded pl-4 pr-2 py-1 justify-between';
            selectedItem.textContent = `${item.title.name} ${item.artist_name.name}`;

            // 「×」ボタンの追加
            const removeButton = document.createElement('button');
            removeButton.innerHTML = '&times;';
            removeButton.className = 'text-black';
            removeButton.onclick = function() {
              selectedItem.remove();
              
              // このアイテムのIDに対応する隠しフィールドを探し、削除する
              const hiddenInputs = document.querySelectorAll('input[name="item_ids[]"]');
              for (let input of hiddenInputs) {
                if (input.value === item.id.toString()) {
                  input.remove(); // 該当する隠しフィールドを削除
                  break; // 一致する最初の要素を削除したらループを抜ける
                }
              }
            };
            selectedItem.appendChild(removeButton);

            selectedItemsContainer.appendChild(selectedItem);

            // 選択されたアイテムのIDを隠しフィールドに保存
            const hiddenInput = document.createElement('input');
            hiddenInput.setAttribute('type', 'hidden');
            hiddenInput.setAttribute('name', 'item_ids[]');
            hiddenInput.value = item.id;
            
            // form変数を使用して隠しフィールドを追加
            const form = document.getElementById('record_form'); // form_withで設定したIDを使用してフォームを特定
            if (form) {
              form.appendChild(hiddenInput); // フォームが存在する場合のみ隠しフィールドを追加
            }
          };

          itemContainer.appendChild(addButton);
          resultsContainer.appendChild(itemContainer);
        });
      }).catch(error => {
        console.error('Error fetching items:', error);
        resultsContainer.style.display = 'none';
      });
  };

  searchInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      fetchItems(searchInput.value);
    }
  });

  searchInput.addEventListener("input", () => {
    if (searchInput.value.trim() === '') {
      resultsContainer.style.display = 'none';
    } else {
      fetchItems(searchInput.value);
    }
  });

  displayExistingItems();
});
