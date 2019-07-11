class Db::ScaCapitalProject < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:capital_projects)

# all SCA Capital Project schools that intersect a district & subdistrict
  def self.sca_projects_intersecting_subdistrict_geom(subdistricts_geom)
      select(
        :geom,
        :project_dsf,
        :name,
        :org_level,
        :capacity,
        :pct_ps,
        :pct_is,
        :pct_hs,
        :guessed_pct,
        :start_date,
        :planned_end_date,
        :total_est_cost,
        :funding_current_budget,
        :funding_previous,
        :pct_funded
      ).where(
        "ST_Intersects(ST_GeomFromText('#{subdistricts_geom.as_text}', #{subdistricts_geom.srid}), geom)")
  end
end
