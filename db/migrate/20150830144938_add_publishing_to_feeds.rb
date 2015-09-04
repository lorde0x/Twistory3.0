class AddPublishingToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :publishing, :boolean, :default => true
  end
end
