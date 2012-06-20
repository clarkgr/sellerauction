class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :seller_id
      t.integer :interest_id
      t.decimal :min_price
      t.timestamps
    end
  end
end
