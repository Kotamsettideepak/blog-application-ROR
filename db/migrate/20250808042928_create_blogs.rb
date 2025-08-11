class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.text :title
      t.text :excerpt
      t.text :content

      t.timestamps
    end
  end
end
