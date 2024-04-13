require 'pg'
require 'csv'

conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')
conn.exec("BEGIN")

begin
  file_path = 'db/import/data/release.tsv'
  # mediumsテーブルから有効なrelease_idを取得
  valid_release_ids = conn.exec("SELECT DISTINCT release_id FROM mediums").values.flatten
  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0") do |row|
    id, gid, name, artist_credit_id = row.values_at(0, 1, 2, 3)
    # 取得した有効なrelease_idに含まれている場合のみ挿入する
    if valid_release_ids.include?(id)
      conn.exec_params("INSERT INTO releases (id, gid, name, artist_credit_id) VALUES ($1, $2, $3, $4)", [id, gid, name, artist_credit_id])
    end
  end
  conn.exec("COMMIT")
  puts "Releases data import completed."
rescue PG::Error => e
  conn.exec("ROLLBACK")
  puts "An error occurred in Releases import. Transaction has been rolled back."
  puts "Error details: #{e.message}"
end
