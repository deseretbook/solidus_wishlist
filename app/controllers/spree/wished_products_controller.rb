class Spree::WishedProductsController < Spree::StoreController
  respond_to :html

  def create
    load_wishlist
    @wished_product = Spree::WishedProduct.new(wished_product_attributes)

    if @wishlist.include? params[:wished_product][:variant_id]
      @wished_product = @wishlist.wished_products.detect {|wp| wp.variant_id == params[:wished_product][:variant_id].to_i }
    else
      @wished_product.wishlist = @wishlist
      @wished_product.save
    end

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wishlist) }
    end
  end

  def update
    load_wished_product
    @wished_product.update_attributes(wished_product_attributes)

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist) }
    end
  end

  def destroy
    load_wished_product
    @wished_product.destroy

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist) }
    end
  end

  private

  def wished_product_attributes
    params.require(:wished_product).permit(:variant_id, :wishlist_id, :remark, :quantity)
  end

  def load_wishlist
    if spree_current_user
      @wishlist = spree_current_user.wishlist
    else
      @wishlist = Spree::Wishlist.get_or_create_by_param(session[:wishlist_access_hash])
      session[:wishlist_access_hash] = @wishlist.access_hash
    end
  end

  def load_wished_product
    @wished_product = Spree::WishedProduct.find(params[:id])
  end
end
