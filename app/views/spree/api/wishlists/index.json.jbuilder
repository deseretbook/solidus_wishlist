current_page = params[:page].present? ? params[:page].to_i : 1
per_page = params[:per_page].present? ? params[:per_page].to_i : Kaminari.config.default_per_page

json.count @wishlists.count
json.total_count @wishlists.total_count
json.current_page current_page
json.per_page per_page
json.pages @wishlists.total_pages
json.wishlists @wishlists, *wishlist_attributes, :id
