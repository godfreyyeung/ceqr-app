require 'rails_helper'

RSpec.describe "Db::HousingPipeline", type: :model do
  describe "attributes by version" do
    context "by school districts" do
      def tests_version(version)
        Db::HousingPipelineBySd.version = version
        db = Db::HousingPipelineBySd.first

        expect(db.district).to be_a String
        expect(db.subdistrict).to be_an String
        expect(db.new_students).to be_an Integer
        expect(db.org_level).to be_a String
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
        Db::HousingPipelineByBoro.version = version
        db = Db::HousingPipelineByBoro.first

        expect(db.borough).to be_a String
        expect(db.new_students).to be_an Integer
        expect(db.borocode).to be_an Integer
      end

      it "2017" do
        tests_version("2017")
      end

      it "2018" do
        tests_version("2018")
      end
    end
  end

  describe "#high_school_students_from_new_housing_by_boro" do
    it "returns hs_students_from_housing value" do
      project_borough = "Manhattan"

      hs_students_from_housing = Db::HousingPipelineByBoro.high_school_students_from_new_housing_by_boro(project_borough)

      expect(hs_students_from_housing[0].borough).to eq(project_borough)
    end
  end

  describe "#housing_pipeline_by_subdistrict" do
    it "returns future_enrollment_new_housing value" do
      subdistricts = ["(2,1)"]

      future_enrollment_new_housing = Db::HousingPipelineBySd.ps_is_students_from_new_housing_by_subdistrict(subdistricts)

      expect(future_enrollment_new_housing[0].district).to eq('2')
      expect(future_enrollment_new_housing[0].subdistrict).to eq('1')
    end
  end
end
