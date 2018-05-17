class AddJidToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :jid, :string
  end
end
