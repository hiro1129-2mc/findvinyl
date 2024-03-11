require 'pg'
require 'csv'

# データベース接続設定
conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')

begin
  # トランザクション開始
  conn.exec("BEGIN")

  # TSVファイルの読み込み
  file_path = 'db/import/data/artist_credit.tsv'
  
  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0") do |row|
    id, name = row.values_at(0, 1)
    # データベースにデータを挿入
    conn.exec_params("INSERT INTO artist_credits (id, name) VALUES ($1, $2)", [id, name])
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
