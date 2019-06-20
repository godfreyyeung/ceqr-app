class Api::V1::TransportationAnalysisResource < JSONAPI::Resource
  attributes(
    :traffic_zone,
    :jtw_study_selection,
    :required_jtw_study_selection,
    :nw_line,
    :ne_line,
    :sw_line,
    :se_line,
    :nw_geoids,
    :ne_geoids,
    :sw_geoids,
    :se_geoids,
  )

  has_one :project
end
