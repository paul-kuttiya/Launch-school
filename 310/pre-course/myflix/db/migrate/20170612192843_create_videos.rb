class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :small_cover
      t.string :large_cover
      t.datetime :created_at
      t.integer :category_id
    end
  end
end
