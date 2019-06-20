class TransportationAnalysis < ApplicationRecord
  before_save :compute_study_data

  after_create :compute_traffic_zone!

  belongs_to :project

  # loads all necessary data by calling ! methods which imply a save
  def load_data!
    compute_traffic_zone!
  end

  private

    # Find, set, and save the traffic zone
    def compute_traffic_zone!
      zones = Db::TrafficZone.for_geom(project.bbls_geom)

      # Currently set traffic zone to most conservative touched by study area
      self.traffic_zone = zones.max

      save!
    end

    # Call necessary methods for computing study selection & area
    def compute_study_data
      compute_required_study_selection
      compute_study_area
      compute_jtw_aggregates
    end
  
    # Find and set the intersecting Census Tracts
    def compute_required_study_selection
      tracts = Db::CensusTract.for_geom(project.bbls_geom)

      self.required_jtw_study_selection = tracts || []
    end

    # Find and set the centroid
    def compute_study_area
      centroid = Db::CensusTract.st_union_geoids_centroid(self.required_jtw_study_selection.concat(self.jtw_study_selection))

      self.jtw_study_area_centroid = centroid
    end

    def compute_jtw_aggregates
      compute_quadrant_polygons
      # compute_aggregates
    end

    def compute_quadrant_polygons
      compute_quadrant_lines
      # compute_quadrant_polygons here
    end

    def compute_quadrant_lines
      nw_line_sql = get_sql_of_line_at_azimuth_from_centroid(self.jtw_study_area_centroid, "315")
      nw_line =  ActiveRecord::Base.connection.execute(nw_line_sql).first["st_asgeojson"]
      ne_line_sql = get_sql_of_line_at_azimuth_from_centroid(self.jtw_study_area_centroid, "45")
      ne_line =  ActiveRecord::Base.connection.execute(ne_line_sql).first["st_asgeojson"]
      sw_line_sql = get_sql_of_line_at_azimuth_from_centroid(self.jtw_study_area_centroid, "135")
      sw_line =  ActiveRecord::Base.connection.execute(sw_line_sql).first["st_asgeojson"]
      se_line_sql = get_sql_of_line_at_azimuth_from_centroid(self.jtw_study_area_centroid, "225")
      se_line =  ActiveRecord::Base.connection.execute(se_line_sql).first["st_asgeojson"]

      self.nw_line = nw_line
      self.ne_line = ne_line
      self.sw_line = sw_line
      self.se_line = se_line

    end

    def get_sql_of_line_at_azimuth_from_centroid(centroid, azimuth)
      line_sql = "SELECT ST_AsGeoJSON("
      line_sql << "  ST_MakeLine(ARRAY["
      line_sql << "      ST_GeomFromText("
      line_sql << "            'Point(" << centroid.x.to_s << " " << centroid.y.to_s << ")', 3857"
      line_sql << "        ),"
      line_sql << "      St_GeomFromText("
      line_sql << "        ST_AsText("
      line_sql << "          ST_Project("
      line_sql << "            ST_GeographyFromText("
      line_sql << "                'Point(" << centroid.x.to_s << " " << centroid.y.to_s << ")'"
      line_sql << "            ),"
      line_sql << "            100000,"
      line_sql <<              "radians(" << azimuth <<  ")"
      line_sql << "          )"
      line_sql << "        ),"
      line_sql << "        3857"
      line_sql << "      )"
      line_sql << "    ]"
      line_sql << "  )"
      line_sql << ")"
      return line_sql
    end


    # def compute_aggregates
    #   compute_geoids_per_quadrant
    #   # compute aggregates here
    # end
end
