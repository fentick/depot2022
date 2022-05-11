#line-item-highlight

require "application_system_test_case"

class LineItemsTest < ApplicationSystemTestCase
  test "check highlight" do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    assert has_css? "tr[class*='line-item-highlight']"
    assert has_css? 'tr.line-item-highlight'

  end
end