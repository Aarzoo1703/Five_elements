class Cart < ApplicationRecord
    has_many :line_items, dependent: :destroy
    def total_price
        line_items.to_a.sum { |item| item.total_price }
        end
    def add_product(product)
        current_item = line_items.find_by(store_id: product.id)   
        if current_item   
            current_item.quantity += 1 
        else
            current_item = line_items.build(store_id: product.id) 
        end
          current_item
        end
end
