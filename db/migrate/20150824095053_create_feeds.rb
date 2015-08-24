class CreateFeeds < ActiveRecord::Migration
	def change
		create_table :feeds do |t|
			t.references :user, index: true, foreign_key: true
			t.string :text_ita, null: false
			t.string :text_eng, null: false
			t.string :image, default: ""
			t.datetime :date
			t.boolean :is_ita_published, default: false
			t.boolean :is_eng_published, default: false

			t.timestamps null: false
		end
	end
end
