class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :user          , :null => false
      t.references :product       , :null => false
      t.datetime   :expires_at    , :null => false
      t.decimal    :start_price   , :null => false, :null => false, :precision => 10, :scale => 2
      t.decimal    :current_price , :null => false, :null => false, :precision => 10, :scale => 2
      t.integer    :decrements    , :null => false, :default => 1
      t.references :seller
      t.timestamps
    end
  end
end
