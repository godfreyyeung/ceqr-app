class Db::HousingPipelineBySd < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:housing_pipeline_by_sd)

  def self.housing_pipeline_by_sd(pairs)
    select(
      "new_students AS students, district, subdistrict, org_level AS level"
    ).where("(district, subdistrict) IN (VALUES #{pairs.join(',')})")
  end
end
