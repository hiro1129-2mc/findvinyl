document.addEventListener('turbo:load', () => {
  const searchInput = document.getElementById("item_search");
  const resultsContainer = document.getElementById("search_results");

  // 初期状態では検索結果のコンテナを非表示に設定
  resultsContainer.style.display = 'none';

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

          let title = item.title.name.length > 10 ? item.title.name.substring(0, 10) + '...　' : item.title.name;
          let artistName = item.artist_name.name.length > 8 ? item.artist_name.name.substring(0, 8) + '...' : item.artist_name.name;

          const spaceToAdd = 12 - title.length;
          let spaces = '';
          if (spaceToAdd > 0) {
            spaces = '　'.repeat(spaceToAdd);
          }
          const combinedText = `${title}${spaces}${artistName}`;

          const itemText = document.createTextNode(combinedText);
          itemContainer.appendChild(itemText);

          const addButton = document.createElement('button');
            addButton.setAttribute('type', 'button');
            addButton.innerHTML = '<span class="i-bi-plus-circle bg-black w-4 h-4" aria-hidden="true"></span>';
            addButton.onclick = () => {
              const selectedItemsContainer = document.getElementById('selected_items');
              const selectedItem = document.createElement('div');
              selectedItem.className = 'flex items-center rounded-2xl bg-white py-1 font-medium text-black ring-1 ring-inset ring-black justify-between w-full mb-1';

              let title = item.title.name.length > 10 ? item.title.name.substring(0, 10) + '...　' : item.title.name;
              let artistName = item.artist_name.name.length > 8 ? item.artist_name.name.substring(0, 8) + '...' : item.artist_name.name;

              const spaceToAdd = 12 - title.length;
              let spaces = '';
              if (spaceToAdd > 0) {
                spaces = '　'.repeat(spaceToAdd);
              }
              selectedItem.textContent = `\u3000${title}${spaces}${artistName}`;

            // 「×」ボタンの追加
            const removeButton = document.createElement('button');
            removeButton.innerHTML = '<span class="i-bi-x-lg bg-black w-4 h-4 mr-4" aria-hidden="true"></span>';
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
  }

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
});
