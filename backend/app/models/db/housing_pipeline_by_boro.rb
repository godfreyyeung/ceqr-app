class Db::HousingPipelineByBoro < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:housing_pipeline_by_boro)

# high school students added by new housing in borough
  def self.high_school_students_from_new_housing_by_boro(project_borough)
    select(
      :borough, "new_students AS hs_students"
    ).where('LOWER(borough) = ?', project_borough.downcase)
  end
end
