require_relative '../../../config/environment'

medium_format_ids_to_delete = [1]

ActiveRecord::Base.transaction do
  # medium_formats ID に紐づく medium の release_id を収集
  medium_release_ids = Medium.where(medium_format_id: medium_format_ids_to_delete).pluck(:release_id).uniq
  
  # releases テーブルから関連する artist_credit_id を収集
  artist_credit_ids = Release.where(id: medium_release_ids).pluck(:artist_credit_id).uniq
  
  # artist_credit_ids に基づいて ArtistCreditName レコードを削除
  ArtistCreditName.where(artist_credit_id: artist_credit_ids).in_batches(of: 20).delete_all
  
  # ArtistCredit レコードを削除
  ArtistCredit.where(id: artist_credit_ids).in_batches(of: 20).delete_all
  
  # これで関連する medium レコードを削除できる
  Medium.where(release_id: medium_release_ids).in_batches(of: 20).delete_all
  
  # 最後に、関連する releases レコードを削除
  Release.where(id: medium_release_ids).in_batches(of: 20).delete_all
end

puts "指定されたmedium_formats IDに紐づくreleasesレコードおよび関連レコードを削除しました。"
