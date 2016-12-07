RSpec.feature 'Wished Product', :js do
  given(:user) { create(:user) }

  context 'add' do
    given(:product) { create(:product) }

    context 'registred user' do
      background do
        sign_in_as! user
      end

      scenario 'when user has a default wishlist' do
        wishlist = create(:wishlist, is_default: true, user: user)

        add_to_wishlist product

        expect(page).to have_content wishlist.name
        expect(page).to have_content product.name
      end

      scenario 'when user has no default but with non-default wishlist' do
        wishlist = create(:wishlist, is_default: false, user: user)

        add_to_wishlist product

        expect(wishlist.reload.is_default).to be true
        expect(page).to have_content wishlist.name
        expect(page).to have_content product.name
      end

      scenario 'when user has no wishlist at all' do
        expect(user.wishlists).to be_empty

        add_to_wishlist product

        expect(user.wishlists.reload.count).to eq(1)
        expect(page).to have_content user.wishlists.first.name
        expect(page).to have_content product.name
      end

      scenario 'when user chooses different quantity of item' do
        create(:wishlist, user: user)

        visit spree.product_path(product)
        fill_in "quantity", with: "15"
        click_button 'Add to wishlist'

        expect(page).to have_content product.name
        expect(page).to have_selector("input[value='15']")
      end
    end

    context 'guest user' do
      scenario 'when guest adds product to wishlist' do
        expect(Spree::Wishlist.count).to eq(0)

        add_to_wishlist product

        expect(Spree::Wishlist.count).to eq(1)

        wishlist = Spree::Wishlist.first

        expect(wishlist.is_default).to be true
        expect(page).to have_content wishlist.name
        expect(page).to have_content product.name
      end

      scenario 'when guest chooses different quantity of item' do
        visit spree.product_path(product)
        fill_in "quantity", with: "15"
        click_button 'Add to wishlist'

        expect(page).to have_content product.name
        expect(page).to have_selector("input[value='15']")
      end
    end
  end

  context 'delete' do
    context 'registred user' do
      given(:wishlist) { create(:wishlist, user: user) }

      background do
        sign_in_as! user
      end

      scenario 'from a wishlist with one wished product' do
        wished_product = create(:wished_product, wishlist: wishlist)

        visit spree.wishlist_path(wishlist)

        wp_path = spree.wished_product_path(wished_product)
        delete_link = find(:xpath, "//table[@id='wishlist']/tbody/tr/td/p/a[@href='#{wp_path}']")
        delete_link.click

        expect(page).not_to have_content wished_product.variant.product.name
      end

      scenario 'randomly from a wishlist with multiple wished products while maintaining ordering by date added' do
        wished_products = [
          create(:wished_product, wishlist: wishlist),
          create(:wished_product, wishlist: wishlist),
          create(:wished_product, wishlist: wishlist),
        ]
        wished_product = wished_products.delete_at(Random.rand(wished_products.length))

        visit spree.wishlist_path(wishlist)

        wp_path = spree.wished_product_path(wished_product)
        delete_link = find(:xpath, "//table[@id='wishlist']/tbody/tr/td/p/a[@href='#{wp_path}']")
        delete_link.click
        pattern = Regexp.new(wished_products.map {|wp| wp.variant.product.name }.join('.*'))

        expect(page).not_to have_content wished_product.variant.product.name
        expect(page).to have_content pattern
      end
    end

    context 'guest user' do
      given(:wishlist) { create(:wishlist) }

      scenario 'from a wishlist with one wished product' do
        wished_product = create(:wished_product, wishlist: wishlist)

        visit spree.wishlist_path(wishlist)

        wp_path = spree.wished_product_path(wished_product)
        delete_link = find(:xpath, "//table[@id='wishlist']/tbody/tr/td/p/a[@href='#{wp_path}']")
        delete_link.click

        expect(page).not_to have_content wished_product.variant.product.name
      end
    end
  end

  private

  def add_to_wishlist(product)
    visit spree.product_path(product)
    click_button 'Add to wishlist'
  end
end
