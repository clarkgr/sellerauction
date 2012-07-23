class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :user            , :null => false
      t.references :product         , :null => false
      t.datetime   :expires_at      , :null => false
      t.decimal    :max_buying_price, :null => false, :precision => 10, :scale => 2
      t.decimal    :current_price   , :null => false, :precision => 10, :scale => 2
      t.decimal    :decrements      , :null => false, :default => 1, :precision => 10, :scale => 2
      t.integer    :quantity        , :null => false, :default => 1
      t.timestamps
    end
  end
end
