class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.references :authorizable, polymorphic: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
