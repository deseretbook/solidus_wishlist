class Spree::WishedProduct < ActiveRecord::Base
  belongs_to :variant
  belongs_to :wishlist

  validate :variant_exists, :wishlist_exists

  def total
    quantity * variant.price
  end

  def display_total
    Spree::Money.new(total)
  end

  private

  def variant_exists
    if Spree::Variant.where(id: variant_id).count.zero?
      errors.add(:variant, 'invalid variant id')
    end
  end

  def wishlist_exists
    if Spree::Wishlist.where(id: wishlist_id).count.zero?
      errors.add(:wishlist, 'invalid wishlist id')
    end
  end
end
