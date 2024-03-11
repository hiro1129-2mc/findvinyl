require 'pg'
require 'csv'

# データベース接続設定
conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')

begin
  # トランザクション開始
  conn.exec("BEGIN")

  # TSVファイルの読み込み
  file_path = 'db/import/data/artist.tsv'
  
  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0") do |row|
    id, gid, name = row.values_at(0, 1, 2)
    # データベースにデータを挿入。主キーが既に存在する場合はスキップ
    conn.exec_params("INSERT INTO artists (id, gid, name) VALUES ($1, $2, $3) ON CONFLICT (id) DO NOTHING", [id, gid, name])
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
