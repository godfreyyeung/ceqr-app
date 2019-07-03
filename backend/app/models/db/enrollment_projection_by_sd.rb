class Db::EnrollmentProjectionBySd < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:enrollment_projection_by_sd)

  # all intermediate schools (IS, PSIS, ISHS) within project district and subdistrict
    def self.enrollment_projection_by_subdistrict(buildYearMaxed, district)
      select(
        "ps, ms, district, school_year"
      ).where("(district) IN (VALUES #{district.join(',')})").where("school_year ILIKE '#{buildYearMaxed}%25'")
    end
end
