class AddPopulationToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :population, :integer
  end
end
