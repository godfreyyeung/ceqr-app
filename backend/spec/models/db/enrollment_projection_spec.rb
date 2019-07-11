require 'rails_helper'

RSpec.describe "Db::EnrollmentProjection", type: :model do
  describe "attributes by version" do
    context "by school districts" do
      def tests_version(version)
        Db::EnrollmentProjectionBySd.version = version
        db = Db::EnrollmentProjectionBySd.first

        expect(db.district).to be_a String
        expect(db.ps).to be_an Integer
        expect(db.is).to be_an Integer
        expect(db.school_year).to be_a String
      end

      it "2017" do
        tests_version("2017")
      end

      it "2018" do
        tests_version("2018")
      end
    end

    context "by boroughs" do
      def tests_version(version)
        Db::EnrollmentProjectionByBoro.version = version
        db = Db::EnrollmentProjectionByBoro.first

        expect(db.borough).to be_a String
        expect(db.hs).to be_an Integer
        expect(db.year).to be_a String
      end

      it "2017" do
        tests_version("2017")
      end

      it "2018" do
        tests_version("2018")
      end
    end
  end

    describe "#enrollment_projection_by_subdistrict_for_year" do
      it "returns an array of future_enrollment_projections" do
        district = '2'
        buildYearMaxed = 2023

        future_enrollment_projections = Db::EnrollmentProjectionBySd.enrollment_projection_by_subdistrict_for_year(buildYearMaxed, district)

        expect(future_enrollment_projections[0].district).to eq(district)
        expect(future_enrollment_projections[0].school_year).to eq('2023-24')
      end
    end

    describe "#enrollment_projection_by_boro_for_year" do
      it "returns an array of hs_projections" do
        project_borough = 'manhattan'
        buildYearMaxed = 2023

        hs_projections = Db::EnrollmentProjectionByBoro.enrollment_projection_by_boro_for_year(buildYearMaxed, project_borough)

        expect(hs_projections[0].borough).to eq(project_borough)
        # although we change this year to an integer for the public schools model, it come froms the database as a string
        expect(hs_projections[0].year).to eq('2023')
      end
    end
end
