class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :user            , :null => false
      t.references :product         , :null => false
      t.datetime   :expires_at      , :null => false
      t.decimal    :max_buying_price, :null => false, :null => false, :precision => 10, :scale => 2
      t.decimal    :current_price   , :null => false, :null => false, :precision => 10, :scale => 2
      t.decimal    :decrements      , :null => false, :null => false, :precision => 10, :scale => 2
      t.references :order
      t.timestamps
    end
  end
end
