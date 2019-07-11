class Db::EnrollmentProjectionByBoro < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:enrollment_projection_by_boro)

# high school student enrollment projections by year and borough
  def self.enrollment_projection_by_boro_for_year(buildYearMaxed, project_borough)
    select(
      :borough, :year, :hs
    ).where(year: buildYearMaxed).where('lower(borough) = ?', project_borough.downcase)
  end
end
