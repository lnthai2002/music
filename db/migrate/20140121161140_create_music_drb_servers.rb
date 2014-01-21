class CreateMusicDrbServers < ActiveRecord::Migration
  def change
    create_table :music_drb_servers do |t|
      t.column :host, :string
      t.column :security_key, :string
      t.column :user_id, :integer
      t.timestamps
    end
  end
end
