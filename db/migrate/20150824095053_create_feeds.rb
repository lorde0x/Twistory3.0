class CreateFeeds < ActiveRecord::Migration
	def change
		create_table :feeds do |t|
			t.references :user, index: true, foreign_key: true
			t.string :text_ita, null: false, :limit => 141
			t.string :text_eng, null: false, :limit => 141
			t.string :image, default: ""
			t.datetime :date
			t.boolean :publishing, default: true
			t.boolean :is_ita_published, default: false
			t.boolean :is_eng_published, default: false
			t.boolean :publishing, default: true

			t.timestamps null: false
		end
	end
end
