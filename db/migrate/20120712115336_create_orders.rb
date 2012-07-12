class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references  :user         , :null => false
      t.references  :seller       , :null => false
      t.references  :product      , :null => false
      t.decimal     :price        , :null => false, :precision => 10, :scale => 2
      t.datetime    :paid_at
      t.datetime    :shipped_at
      t.timestamps
    end
  end
end
