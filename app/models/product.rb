class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: { message: 'must be given please.'}
  
  validates :title, allow_blank: true, uniqueness: true, length: {minimum: 10}

  validates :price, numericality: { greater_than_or_equal_to: 0.01}
  
  validates :image_url, allow_blank: true, format: { 
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG or PNG image'
  }

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  private

  #ensure that there are not line items referencing this product.
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
