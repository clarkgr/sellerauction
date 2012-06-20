class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :user
      t.references :product
      t.datetime   :expires_at
      t.float      :start_price
      t.float      :current_price
      t.integer    :decrements
      t.references :seller
      t.timestamps
    end
  end
end
