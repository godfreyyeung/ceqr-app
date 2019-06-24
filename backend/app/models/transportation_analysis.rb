class TransportationAnalysis < ApplicationRecord
  before_save :compute_study_data

  after_create :compute_traffic_zone!

  belongs_to :project

  # loads all necessary data by calling ! methods which imply a save
  def load_data!
    compute_traffic_zone!
  end

#  private

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
      centroid_pt_text = get_centroid_pt_text(self.jtw_study_area_centroid)
      intercardinal_pts_text = compute_intercardinal_pts(centroid_pt_text)
      compute_quadrant_lines(centroid_pt_text, intercardinal_pts_text)
      # compute_quadrant_polygons
      # compute_quadrant_geoids

    end

    def compute_intercardinal_pts(centroid_pt_text)
      nw_pt_text = get_intercardinal_pt_text(centroid_pt_text, "315")
      ne_pt_text = get_intercardinal_pt_text(centroid_pt_text, "45")
      sw_pt_text = get_intercardinal_pt_text(centroid_pt_text, "135")
      se_pt_text = get_intercardinal_pt_text(centroid_pt_text, "225")
      return { "nw" => nw_pt_text, "ne" => ne_pt_text, "sw" => sw_pt_text, "se" => se_pt_text }
    end

    def compute_quadrant_lines(centroid_pt_text, intercardinal_pts_text)
      nw_line_sql = get_sql_of_intercardinal_line_geojson(centroid_pt_text, intercardinal_pts_text["nw"])
      nw_line_geojson =  ActiveRecord::Base.connection.execute(nw_line_sql).first["st_asgeojson"]
      ne_line_sql = get_sql_of_intercardinal_line_geojson(centroid_pt_text, intercardinal_pts_text["ne"])
      ne_line_geojson =  ActiveRecord::Base.connection.execute(ne_line_sql).first["st_asgeojson"]
      sw_line_sql = get_sql_of_intercardinal_line_geojson(centroid_pt_text, intercardinal_pts_text["sw"])
      sw_line_geojson =  ActiveRecord::Base.connection.execute(sw_line_sql).first["st_asgeojson"]
      se_line_sql = get_sql_of_intercardinal_line_geojson(centroid_pt_text, intercardinal_pts_text["se"])
      se_line_geojson =  ActiveRecord::Base.connection.execute(se_line_sql).first["st_asgeojson"]

      self.nw_line_geojson = nw_line_geojson
      self.ne_line_geojson = ne_line_geojson
      self.sw_line_geojson = sw_line_geojson
      self.se_line_geojson = se_line_geojson
    end

    # def compute_quadrant_polygons
    #   n_polygon_sql = get_sql_of_quadrant(self.centroid_pt, self.ne_pt_text, self.nw_pt_text)
    #   n_polygon_geojson =  ActiveRecord::Base.connection.execute(n_polygon_sql).first["st_asgeojson"]
    #   e_polygon_sql = get_sql_of_quadrant(self.centroid_pt, self.ne_pt_text, self.se_pt_text)
    #   e_polygon_geojson =  ActiveRecord::Base.connection.execute(e_polygon_sql).first["st_asgeojson"]
    #   s_polygon_sql = get_sql_of_quadrant(self.centroid_pt, self.sw_pt_text, self.se_pt_text)
    #   s_polygon_geojson =  ActiveRecord::Base.connection.execute(s_polygon_sql).first["st_asgeojson"]
    #   w_polygon_sql = get_sql_of_quadrant(self.centroid_pt, self.sw_pt_text, self.nw_pt_text)
    #   w_polygon_geojson =  ActiveRecord::Base.connection.execute(w_polygon_sql).first["st_asgeojson"]

    #   self.n_polygon_geojson = n_polygon_geojson
    #   self.e_polygon_geojson = e_polygon_geojson
    #   self.s_polygon_geojson = s_polygon_geojson
    #   self.w_polygon_geojson = w_polygon_geojson
    # end

    # def get_centroid_pt_text(centroid)
    #   return "'Point(" << centroid.x.to_s << " " << centroid.y.to_s << ")'"
    # end

    def get_centroid_pt_text(centroid)
      return "'Point(" << centroid.x.to_s << " " << centroid.y.to_s << ")'"
    end

    def get_intercardinal_pt_text(centroid_pt_text, azimuth)
      intercardinal_pt_sql = "SELECT ST_AsText("
      intercardinal_pt_sql << "   ST_Project("
      intercardinal_pt_sql << "     ST_GeographyFromText("
      intercardinal_pt_sql <<         centroid_pt_text
      intercardinal_pt_sql << "     ),"
      intercardinal_pt_sql << "     100000,"
      intercardinal_pt_sql << "      radians(" << azimuth <<  ")"
      intercardinal_pt_sql << "   )"
      intercardinal_pt_sql << " )"

      return "'" << ActiveRecord::Base.connection.execute(intercardinal_pt_sql).first["st_astext"] << "'"
    end

    def get_sql_of_intercardinal_line_geojson(centroid_pt_text, intercardinal_pt_text)
      line_sql = "SELECT ST_AsGeoJSON("
      line_sql << "  ST_MakeLine(ARRAY["
      line_sql << "      ST_GeomFromText("
      line_sql << "            " << centroid_pt_text << ", 3857"
      line_sql << "        ),"
      line_sql << "      St_GeomFromText("
      line_sql <<             intercardinal_pt_text
      line_sql <<            ", 3857"
      line_sql << "      )"
      line_sql << "    ]"
      line_sql << "  )"
      line_sql << ")"

      return line_sql
    end

    # def get_sql_of_quadrant(centroid, pt_a, pt_b)
    #   quadrant_sql =  "SELECT ST_AsGeoJSON("
    #   quadrant_sql << "  ST_Polygon("
    #   quadrant_sql << "   ST_MakeLine(ARRAY["
    #   quadrant_sql << "       ST_GeomFromText("
    #   quadrant_sql <<             centroid 
    #   quadrant_sql << "         , 4326),"
    #   quadrant_sql << "       St_GeomFromText("
    #   quadrant_sql <<             pt_a
    #   quadrant_sql << "         , 4326),"
    #   quadrant_sql << "       St_GeomFromText("
    #   quadrant_sql <<             pt_v
    #   quadrant_sql << "         , 4326),"
    #   quadrant_sql << "       ST_GeomFromText("
    #   quadrant_sql <<             centroid
    #   quadrant_sql << "         , 4326)z,"
    #   quadrant_sql << "     ]"
    #   quadrant_sql << "   ),"
    #   quadrant_sql << "   4326"
    #   quadrant_sql << "  )"

    #   return quadrant_sql
    # end

    # def get_quadrant_geoids(quadrant_polygon_geojson)
    #   line_sql = "SELECT geoid FROM ctpp_censustract_centroids WHERE"
    #   line_sql <<  "ST_CONTAINS("
    #   line_sql <<    "ST_GeomFromGeoJSON(" << quadrant_polygon_geojson << "),"
    #   line_sql <<    "ST_GeographyFromText(CENTROID)"
    #   line_sql <<  ")"
    #   return line_sql
    # end

    # def compute_aggregates
    #   compute_geoids_per_quadrant
    #   # compute aggregates here
    # end
end
