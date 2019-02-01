class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
		rename_column :images, :path, :location
  end
end
