class AddLineColumnsToTransportationAnalysis < ActiveRecord::Migration[5.2]
  def change
    add_column :transportation_analyses, :nw_line, :string
    add_column :transportation_analyses, :ne_line, :string
    add_column :transportation_analyses, :sw_line, :string
    add_column :transportation_analyses, :se_line, :string

    TransportationAnalysis.all.each do |a|
      a.send(:compute_study_area)
      a.send(:compute_jtw_aggregates)
      a.save!
    end

    add_column :transportation_analyses, :nw_geoids, 'varchar(11)', default: [], array: true 
    add_column :transportation_analyses, :ne_geoids, 'varchar(11)', default: [], array: true 
    add_column :transportation_analyses, :sw_geoids, 'varchar(11)', default: [], array: true 
    add_column :transportation_analyses, :se_geoids, 'varchar(11)', default: [], array: true 
  end
end
