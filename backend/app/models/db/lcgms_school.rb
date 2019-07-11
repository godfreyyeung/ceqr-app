class Db::LcgmsSchool < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:lcgms)

# all lcgms schools that intersect a district & subdistrict
  def self.lcgms_intersecting_subdistrict_geom(subdistricts_geom)
      select(
        :geom, :name, :address, :bldg_id, :org_id, :org_level, :ps_enroll, :is_enroll, :hs_enroll
      ).where(
        "ST_Intersects(ST_GeomFromText('#{subdistricts_geom.as_text}', #{subdistricts_geom.srid}), geom)")
  end
end
