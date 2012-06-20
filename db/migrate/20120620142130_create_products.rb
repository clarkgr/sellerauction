class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string      :code         , :null => false
      t.string      :name         , :null => false
      t.text        :description
      t.references  :category
      t.string      :image
      t.timestamps
    end
  end
end
