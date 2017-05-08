module Spree
  module Wishlists
    module ApiHelpers
      ATTRIBUTES = %i[
wishlist_attributes
wished_product_attributes
]

      mattr_reader(*ATTRIBUTES)

      @@wishlist_attributes = %i[
access_hash user_id name is_private is_default
]

      @@wished_product_attributes = %i[
id variant_id wishlist_id remark
]
    end
  end
end
