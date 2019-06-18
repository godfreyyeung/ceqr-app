class AddNwLineToTransportationAnalysis < ActiveRecord::Migration[5.2]
  def change
    add_column :transportation_analyses, :nw_line, :string
  end
end
