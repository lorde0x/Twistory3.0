json.array!(@feeds) do |feed|
  json.extract! feed, :id, :user_id, :text_ita, :text_eng, :image, :date, :is_ita_published, :is_eng_published
  json.url feed_url(feed, format: :json)
end
