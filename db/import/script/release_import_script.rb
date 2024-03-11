require 'pg'
require 'csv'

# データベース接続設定
conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')

# トランザクション開始
conn.exec("BEGIN")

begin
  # TSVファイルの読み込み
  file_path = 'db/import/data/release.tsv'
  
  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0") do |row|
    id, gid, name, artist_credit_id = row.values_at(0, 1, 2, 3)
    # データベースにデータを挿入
    conn.exec_params("INSERT INTO releases (id, gid, name, artist_credit_id) VALUES ($1, $2, $3, $4)", [id, gid, name, artist_credit_id])
  end
  
  # トランザクションをコミット
  conn.exec("COMMIT")
  puts "Data import completed."

rescue PG::Error => e
  # エラーが発生した場合はトランザクションをロールバック
  conn.exec("ROLLBACK")
  puts "An error occurred. Transaction has been rolled back."
  puts "Error details: #{e.message}"
end
