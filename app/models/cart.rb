class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)

    if current_item 
      current_item.quantity +=1
      current_item.price = product.price
    else
      current_item = line_items.build(product_id: product.id)
      current_item.price = product.price
    end

    current_item
  end

  def reduce_product(product)
    current_item = line_items.find_by(product_id: product.id)
    
    if current_item.quantity > 1
      current_item.quantity = current_item.quantity - 1
      current_item.price = product.price

      current_item
    else
      current_item.destroy
    end
  end

  def total_price
    line_items.sum { |item| item.total_price }
  end

end
