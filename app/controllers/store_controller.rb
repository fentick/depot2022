class StoreController < ApplicationController
  include StoreIndexCount

  def index
    @products = Product.order(:title)

    store_index_count

  end
end
