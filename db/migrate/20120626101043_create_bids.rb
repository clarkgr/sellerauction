class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :seller_id,   :null => false
      t.integer :interest_id, :null => false
      t.decimal :min_price,   :null => false, :precision => 10, :scale => 2
      t.timestamps
    end
  end
end
