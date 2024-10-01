class UserRecordStatsService
  require 'ostruct'

  def initialize(user)
    @user = user
  end

  def monthly_creation_count(date)
    from_date, to_date = month_range(date)
    base_query(from_date, to_date).group_by_day(:created_at).count
  end

  def artist_name_distribution(date)
    from_date, to_date = month_range(date)
    results = base_query(from_date, to_date).joins(item: :artist_name)
                                            .group('artist_names.name').count
    sorted_results = results.sort_by { |_, count| -count }

    if sorted_results.length > 13
      top_results = sorted_results.first(12).to_h
      etc_count = sorted_results.drop(12).sum { |_, count| count }
      top_results['etc.'] = etc_count
    else
      top_results = sorted_results.to_h
    end

    top_results
  end

  def top_titles_by_month(date)
    from_date, to_date = month_range(date)
    results = base_query(from_date, to_date)
              .joins(item: %i[title artist_name])
              .select('titles.name AS title_name, artist_names.name AS artist_name, COUNT(*) AS count')
              .group('titles.name', 'artist_names.name')
              .order(Arel.sql('COUNT(*) DESC'))
              .limit(10)
    results.map do |result|
      OpenStruct.new(
        title_name: result.title_name,
        artist_name: result.artist_name,
        count: result.count
      )
    end
  end

  def fetch_data_for_month(date)
    from_date, to_date = month_range(date)
    RecordItem.where(created_at: from_date..to_date)
  end

  private

  def month_range(date)
    [date.beginning_of_month, date.end_of_month]
  end

  def base_query(from_date, to_date)
    RecordItem.joins(:record)
              .where(records: { user_id: @user.id }, record_items: { created_at: from_date..to_date })
  end
end
