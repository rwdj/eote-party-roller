class CreateDicePoolTable < ActiveRecord::Migration[5.2]
  def change
    create_table :dice do |t|
      t.string :name
      t.index :name
      t.jsonb :sides, default: []
      t.index :sides, using: :gin
    end
    create_table :side_types do |t|
      t.jsonb :results, default: {}
      t.index :results, using: :gin
      t.string :md5_hash
    end
  end
end
