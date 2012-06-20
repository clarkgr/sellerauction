# Products

product_names = ["Ruby on Rails Tote", "Ruby on Rails Bag", "Ruby on Rails Baseball Jersey",
  "Ruby on Rails Jr. Spaghetti", "Ruby on Rails Mug", "Ruby on Rails Ringer T-Shirt",
  "Ruby on Rails Stein", "Ruby Baseball Jersey", "Apache Baseball Jersey", "Spree Baseball Jersey",
  "Spree Stein", "Spree Jr. Spaghetti", "Spree Mug", "Spree Ringer T-Shirt", "Spree Tote", "Spree Bag"]
  
category_names = ["Clothing", "Office", "Fun"]

product_names.each do |product_name|
  category_name = category_names[rand(category_names.length)]
  product = Product.where{name == product_name}.
              first_or_create :description => "Lorem ipsum dolor sit amet, consectetuer adipiscing elit." +
              " Nulla nonummy aliquet mi. Proin lacus. Ut placerat. Proin consequat, justo sit amet tempus " +
              "consequat, elit est adipiscing odio, ut egestas pede eros in diam. Proin varius, lacus vitae " +
              "suscipit varius, ipsum eros convallis nisi, sit amet sodales lectus pede non est. Duis augue. " +
              "Suspendisse hendrerit pharetra metus. Pellentesque habitant morbi tristique senectus et netus et " +
              "malesuada fames ac turpis egestas. Curabitur nec pede. Quisque volutpat, neque ac porttitor " +
              "sodales, sem lacus rutrum nulla, ullamcorper placerat ante tortor ac odio. Suspendisse vel libero. " +
              "Nullam volutpat magna vel ligula. Suspendisse sit amet metus. Nunc quis massa. Nulla " +
              "facilisi. In enim. In venenatis nisi id eros. Lorem ipsum dolor sit amet, consectetuer " +
              "adipiscing elit. Nunc sit amet felis sed lectus tincidunt egestas. Mauris nibh.",
              :category => Category.where{name == category_name}.first_or_create,
              :code => Digest::MD5.hexdigest(product_name)
end
  
seller_names = ["AuctHouse", "Frame", "E-shoping", "Multivision"]

seller_names.each do |seller_name|
  
  seller = Seller.where{email == "#{seller_name.underscore}@seller.com"}.
                  first_or_create :name => seller_name, :password => "#{seller_name.underscore}123"
                  
  Product.order("RAND()").limit(Product.count / 2).each do |product|
    stock = seller.stocks.build
    stock.product = product
    stock.price = 30 + (2 * product.id) + (rand(10) * (-1 * rand(2)))
    stock.quantity = rand(16)
    stock.save
  end
  
end


