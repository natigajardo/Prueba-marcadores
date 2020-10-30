json.extract! bookmark, :id, :name, :bookmark_url, :kind_id, :category_id, :created_at, :updated_at
json.url bookmark_url(bookmark, format: :json)
