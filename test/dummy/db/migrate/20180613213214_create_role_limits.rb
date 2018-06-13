class CreateRoleLimits < ActiveRecord::Migration[5.2]
  def change
    create_table :role_limits do |t|
      t.references :role, foreign_key: true
      t.string :sample

      t.timestamps
    end
  end
end
