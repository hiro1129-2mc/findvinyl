require 'pg'
require 'csv'

# データベース接続設定
conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')

# トランザクション開始
conn.exec("BEGIN")

begin
  # TSVファイルの読み込み
  file_path = 'db/import/data/medium.tsv'
  
  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0") do |row|
    # "\N"をnilに置き換える
    row = row.map { |value| value == "\\N" ? nil : value }
    id, release_id, medium_format_id = row.values_at(0, 1, 2)
    # データベースにデータを挿入
    begin
      conn.exec_params("INSERT INTO mediums (id, release_id, medium_format_id) VALUES ($1, $2, $3)", [id, release_id, medium_format_id])
    end
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
