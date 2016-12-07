class Spree::Wishlist < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class
  has_many :wished_products, dependent: :destroy
  before_create :set_access_hash

  validates :name, presence: true

  def include?(variant_id)
    wished_products.map(&:variant_id).include? variant_id.to_i
  end

  def to_param
    access_hash
  end

  def self.get_by_param(param)
    Spree::Wishlist.find_by(access_hash: param)
  end

  def self.get_or_create_by_param(access_hash, options = {})
    Spree::Wishlist.get_by_param(access_hash) ||
      Spree::Wishlist.create(name: Spree.t(:default_wishlist_name), is_default: true)
  end

  def can_be_read_by?(user)
    !is_private? || user == self.user
  end

  def is_default=(value)
    self[:is_default] = value
    return unless is_default?
    Spree::Wishlist.where(is_default: true, user_id: user_id).where.not(id: id).update_all(is_default: false)
  end

  def is_public?
    !is_private?
  end

  private

  def set_access_hash
    random_string = SecureRandom.hex(16)
    self.access_hash = Digest::SHA1.hexdigest("--#{user_id}--#{random_string}--#{Time.zone.now}--")
  end
end
