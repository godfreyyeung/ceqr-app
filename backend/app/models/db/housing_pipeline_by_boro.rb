class Db::HousingPipelineByBoro < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:housing_pipeline_by_boro)

  def self.high_school_students_from_housing(project_borough)
    select(
      "borough, new_students AS hs_students"
    ).where('lower(borough) = ?', project_borough.downcase)
  end
end
