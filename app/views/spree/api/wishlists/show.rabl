object @wishlist
attributes(*wishlist_attributes + [:id])

child wished_products: :wished_products do
  attributes(*wished_product_attributes)
end
