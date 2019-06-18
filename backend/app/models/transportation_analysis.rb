class TransportationAnalysis < ApplicationRecord
  before_save :compute_study_data

  after_create :compute_traffic_zone!

  belongs_to :project

  # loads all necessary data by calling ! methods which imply a save
  def load_data!
    compute_traffic_zone!
  end

  private
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

    def compute_quadrant_lines
      centroid = self.jtw_study_area_centroid
      nw_line_sql = "SELECT ST_AsGeoJSON("
      nw_line_sql << "  ST_MakeLine(ARRAY["
      nw_line_sql << "      ST_GeomFromText("
      nw_line_sql << "            'Point(" << centroid.x.to_s << " " << centroid.y.to_s << ")', 4326"
      nw_line_sql << "        ),"
      nw_line_sql << "      St_GeomFromText("
      nw_line_sql << "        ST_AsText("
      nw_line_sql << "          ST_Project("
      nw_line_sql << "            ST_GeographyFromText("
      nw_line_sql << "                'Point(" << centroid.x.to_s << " " << centroid.y.to_s << ")'"
      nw_line_sql << "            ),"
      nw_line_sql << "            100000,"
      nw_line_sql << "            225"
      nw_line_sql << "          )"
      nw_line_sql << "        ),"
      nw_line_sql << "        4326"
      nw_line_sql << "      )"
      nw_line_sql << "    ]"
      nw_line_sql << "  )"
      nw_line_sql << ")"
      nw_line =  ActiveRecord::Base.connection.execute(nw_line_sql).first["st_asgeojson"]
      self.nw_line = nw_line
    end

    def compute_quadrant_polygons
      compute_quadrant_lines
      # compute_quadrant_polygons here
    end

    # def compute_aggregates
    #   compute_geoids_per_quadrant
    #   # compute aggregates here
    # end

    def compute_jtw_aggregates
      compute_quadrant_polygons
      # compute_aggregates
    end

    # Call necessary methods for computing study selection & area
    def compute_study_data
      compute_required_study_selection
      compute_study_area
      compute_jtw_aggregates
    end

    # Find, set, and save the traffic zone
    def compute_traffic_zone!
      zones = Db::TrafficZone.for_geom(project.bbls_geom)

      # Currently set traffic zone to most conservative touched by study area
      self.traffic_zone = zones.max

      save!
    end
end
