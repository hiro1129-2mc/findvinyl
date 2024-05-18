class RecordItemService
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
    results.sort_by { |_, count| -count }.to_h
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
