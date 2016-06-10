class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.references :user, :video
      t.integer :order
      t.boolean :deleted, default: false
      t.timestamps
    end
  end
end
