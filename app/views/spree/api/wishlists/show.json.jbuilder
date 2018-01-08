json.(@wishlist, *wishlist_attributes, :id)
json.wished_products @wishlist.wished_products, *wished_product_attributes
