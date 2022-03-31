class CopyProductPrice < ActiveRecord::Migration[7.0]
  def up
    LineItem.all.each do |line_item|
      product = Product.find(line_item.product_id)
      line_item.price = product.price 
      line_item.save
    end
  end

  def down
    LineItem.all.each do |line_item|
      line_item.price = 0
      line_item.save!
    end
  end
end
