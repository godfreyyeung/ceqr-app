class Db::EnrollmentPctBySd < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:enrollment_pct_by_sd)

# future enrollment multipliers by district and subdistrict
  def self.enrollment_percent_by_subdistrict(subdistrict_pairs)
    where("(district, subdistrict) IN (VALUES #{subdistrict_pairs.join(',')})")
  end
end
