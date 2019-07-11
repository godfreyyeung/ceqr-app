class Db::DoeSignificantUtilizationChange < DataRecord
  self.table_name = DataPackage.latest_for(:public_schools).table_name_for(:significant_utilization_changes)

# all DOE Significant Utilization Changes matching list of building IDs from project
  def self.doe_util_changes_matching_with_building_ids(buildingsBldgIds)
    select(
      :at_scale_year, :at_scale_enroll, :bldg_id, :bldg_id_additional, :org_id, :url, :vote_date, :title
    ).where(
      "bldg_id IN (#{buildingsBldgIds}) OR bldg_id_additional IN (#{buildingsBldgIds})"
    )
  end
end
