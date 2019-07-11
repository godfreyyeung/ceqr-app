class Db::SchoolSubdistrict < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:school_subdistricts)

# all subdistricts that intersect with a project's bbl's geometry
  def self.intersecting_with_bbls(bbls_geom)
    select(
      "DISTINCT geom, district, subdistrict"
    ).where(
      "ST_Intersects(ST_GeomFromText('#{bbls_geom.as_text}', #{bbls_geom.srid}), geom)"
    )
  end

# all subdistricts that match a "pair" of district & subdistrict values, less expensive then re-querying for intersecting geometry (intersecting_with_bbls)
# used in public schools analysis model to query for geometry of specific subdistricts
# also used in public schools analysis model to check whether a school is in a "school choice zone"
# intersecting_with_bbls query must be run for a project before we run this query
  def self.for_subdistrict_pairs(subdistrict_pairs)
    select(:geom, :district, :subdistrict, :school_choice_ps, :school_choice_is)
    where("(district, subdistrict) IN (#{subdistrict_pairs.join(',')})")
  end

# union all of subdistrict geometry for a project
  def self.st_union_subdistricts(subdistrict_pairs)
    select('ST_MULTI(ST_UNION(geom))').where("(district, subdistrict) IN (#{subdistrict_pairs.join(',')})").first.st_multi
  end

end
