class CreateReview < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :rating
      t.references :user, :video
      t.timestamps
    end
  end
end
