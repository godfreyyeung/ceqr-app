class Db::HousingPipelineBySd < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:housing_pipeline_by_sd)

# primary & intermediate school students added by new housing in subdistrict
  def self.ps_is_students_from_new_housing_by_subdistrict(subdistrict_pairs)
    select(
      "new_students AS students", :district, :subdistrict, "org_level AS level"
    ).where("(CAST(district AS int), CAST(subdistrict AS int)) IN (VALUES #{subdistrict_pairs.join(',')})")
  end
end
