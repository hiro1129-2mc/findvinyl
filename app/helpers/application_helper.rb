module ApplicationHelper
  def default_meta_tags
    {
      site: 'VinylLog',
      title: 'VinylLog',
      reverse: true,
      charset: 'utf-8',
      description: 'レコードショップ検索・レコードのリスト作成・聴いたレコードの記録ができるサービスです。',
      keywords: 'レコード,アナログレコード,Vinyl',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },

      twitter: {
        card: 'summary_large_image',
        site: '@',
        image: image_url('ogp.png')
      }
    }
  end
end
