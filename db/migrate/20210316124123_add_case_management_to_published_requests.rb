class AddCaseManagementToPublishedRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :published_requests, :case_management, :string
  end
end
