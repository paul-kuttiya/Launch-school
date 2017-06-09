class AddColumnCompletedToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :completed, :boolean, default: 'f'
    add_column :todos, :completed_at, :string
  end
end
