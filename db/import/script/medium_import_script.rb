require 'pg'
require 'csv'

conn = PG.connect(dbname: 'findvinyl_development', user: 'postgres', password: 'password', host: 'db')
conn.exec("BEGIN")

begin
  # 外部キー制約を一時的に無効化
  conn.exec("SET session_replication_role = 'replica'")

  file_path = 'db/import/data/medium.tsv'
  # medium_formatsのIDを取得し、存在するIDのリストを作成
  valid_ids = conn.exec("SELECT id FROM medium_formats").values.flatten

  CSV.foreach(file_path, col_sep: "\t", headers: false, quote_char: "\0") do |row|
    row = row.map { |value| value == "\\N" ? nil : value }
    id, release_id, medium_format_id = row.values_at(0, 1, 2)
    # medium_format_idがnilでなく、有効なIDリストに含まれている場合のみ挿入する
    if medium_format_id && valid_ids.include?(medium_format_id)
      conn.exec_params("INSERT INTO mediums (id, release_id, medium_format_id) VALUES ($1, $2, $3)", [id, release_id, medium_format_id])
    end
  end

  # 外部キー制約を再び有効化
  conn.exec("SET session_replication_role = 'origin'")
  conn.exec("COMMIT")
  puts "Data import completed."
rescue PG::Error => e
  conn.exec("ROLLBACK")
  puts "An error occurred in Mediums import. Transaction has been rolled back."
  puts "Error details: #{e.message}"
ensure
  conn.close if conn
end
