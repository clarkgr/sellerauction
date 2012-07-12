class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references  :product      , :null => false
      t.references  :seller       , :null => false
      t.decimal     :price        , :null => false, :precision => 10, :scale => 2
      t.integer     :quantity
      t.timestamps
    end
  end
end
