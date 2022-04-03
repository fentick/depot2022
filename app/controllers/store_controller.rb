class StoreController < ApplicationController
  include StoreIndexCount
  include CurrentCart

  before_action :set_cart

  def index
    @products = Product.order(:title)

    store_index_count
#    if session[:counter].nil?
#      session[:counter] = 1
#    else 
#      session[:counter] = session[:counter] + 1
#    end
  end
end
