require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  test "check carts" do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    assert has_text? 'Your Cart'

    click_on 'Empty Cart'

    assert has_no_text? 'Your Cart'

  end
end