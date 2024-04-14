require 'pg'
require 'csv'

conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')

begin
  conn.exec("BEGIN")
  file_path = 'db/import/data/release.tsv'
  # mediumsテーブルから有効なrelease_idを取得
  valid_release_ids = conn.exec("SELECT DISTINCT release_id FROM mediums").values.flatten
  batch_counter = 0 

  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0").with_index do |row, index|
    id, gid, name, artist_credit_id = row.values_at(0, 1, 2, 3)
    # 取得した有効なrelease_idに含まれている場合のみ挿入する
    if valid_release_ids.include?(id)
      conn.exec_params("INSERT INTO releases (id, gid, name, artist_credit_id) VALUES ($1, $2, $3, $4) ON CONFLICT (id) DO UPDATE SET gid = EXCLUDED.gid, name = EXCLUDED.name, artist_credit_id = EXCLUDED.artist_credit_id", [id, gid, name, artist_credit_id])
      batch_counter += 1
    end

    # 10件ごとにトランザクションをコミットし、新たなトランザクションを開始
    if batch_counter >= 10
      conn.exec("COMMIT")
      conn.exec("BEGIN")
      batch_counter = 0
    end
  end

  # 残りのレコードをコミット
  if batch_counter > 0
    conn.exec("COMMIT")
  end

  puts "Data import completed."
rescue PG::Error => e
  conn.exec("ROLLBACK")
  puts "An error occurred in Releases import. Transaction has been rolled back."
  puts "Error details: #{e.message}"
ensure
  conn.close if conn
end
