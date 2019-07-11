class Db::EnrollmentProjectionBySd < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:enrollment_projection_by_sd)

# primary and intermediate school student enrollment projections by year and borough
  def self.enrollment_projection_by_subdistrict_for_year(buildYearMaxed, district)
    select(
      :ps, :is, :district, :school_year
    ).where(district: district).where("school_year ILIKE '%#{buildYearMaxed}%'")
  end
end
