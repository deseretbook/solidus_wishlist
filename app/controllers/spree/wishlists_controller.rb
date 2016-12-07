class Spree::WishlistsController < Spree::StoreController
  helper 'spree/products'

  before_action :find_wishlist, only: [:destroy, :show, :update, :edit]
  before_action :restrict_unauthenticated, except: [:show, :default]

  respond_to :html
  respond_to :js, only: :update

  def new
    @wishlist = Spree::Wishlist.new
    respond_with(@wishlist)
  end

  def index
    load_wishlists
    respond_with(@wishlist)
  end

  def edit
    respond_with(@wishlist)
  end

  def update
    @wishlist.update_attributes wishlist_attributes
    respond_with(@wishlist)
  end

  def show
    respond_with(@wishlist)
  end

  def default
    load_wishlist
    respond_with(@wishlist) do |format|
      format.html { render :show }
    end
  end

  def create
    @wishlist = Spree::Wishlist.new wishlist_attributes
    @wishlist.user = spree_current_user
    @wishlist.save
    respond_with(@wishlist)
  end

  def destroy
    @wishlist.destroy
    respond_with(@wishlist) do |format|
      format.html { redirect_to account_path }
    end
  end

  private

  def restrict_unauthenticated
    redirect_to spree.root_path unless spree_current_user
  end

  def wishlist_attributes
    params.require(:wishlist).permit(:name, :is_default, :is_private)
  end

  def load_wishlist
    @wishlist = spree_current_user.wishlist
  end

  def load_wishlists
    @wishlists = spree_current_user.wishlists
  end

  # Isolate this method so it can be overwritten
  def find_wishlist
    @wishlist = Spree::Wishlist.find_by!(access_hash: params[:id])
  end
end
