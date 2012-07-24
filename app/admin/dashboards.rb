ActiveAdmin::Dashboards.build do

  section "Profile" do
    div do
      "Welcome, #{current_user.name_or_email}"
    end
    div do
      if current_user.is_a?(Seller)
        link_to "Edit your info", edit_seller_path(current_user)
      elsif current_user.is_a?(Buyer)
        link_to "Edit your info", edit_buyer_path(current_user)
      end
    end
  end
  
  section "Recent interests", :if => Proc.new { current_user.type == "Buyer" } do
    table_for current_user.interests.order{ created_at.desc } do
      column :product do |interest|
        span( image_tag(interest.product.image_url(:thumb), :style => "vertical-align:middle") + interest.product.name)
      end
      column :current_price do |interest|
        number_to_currency interest.current_price
      end
      column :expires_at do |interest|
        div I18n.l(interest.expires_at, :format => '%Y-%m-%d %H:%M')
        div do
          if interest.expired?
            "Expired"
          else
            "Expires in #{time_ago_in_words(interest.expires_at)}"
          end
        end
      end
      column do |interest|
        link_to "Details", interest
      end
    end
  end
  
  section "Recent orders", :if => Proc.new { !current_user.type.blank? } do
    table_for current_user.orders.order{ created_at.desc } do
      column :product
      column :user if current_user.type == "Seller"
      column :price do |order|
        number_to_currency order.price
      end
      column :paid_at
      column :shipped_at
      column do |order|
        link_to "Details", order
      end
    end
  end
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
