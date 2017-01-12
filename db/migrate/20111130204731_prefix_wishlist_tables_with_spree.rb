class PrefixWishlistTablesWithSpree < ActiveRecord::Migration[4.2]
  def change
    rename_table :wishlists, :spree_wishlists
    rename_table :wished_products, :spree_wished_products
  end
end
