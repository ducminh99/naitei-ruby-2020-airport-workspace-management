require "rails_helper"

RSpec.describe Unit, type: :model do
  let(:unit) {FactoryBot.create :unit}
  let!(:unit_fail) {FactoryBot.build :unit, name: nil}

  describe "Validation" do
    context "when all required fields given" do
      it "should be true" do
        expect(unit.valid?).to eq true
      end
    end

    context "when missing required fields" do
      it "should be false" do
        expect(unit_fail.valid?).to eq false
      end
    end
  end

  describe "Associations" do
    it "should has many users" do
      is_expected.to have_many(:users).dependent :nullify
    end
  end

  describe "Scopes" do
    include_examples "create example unit"

    context "when filtered active unit" do
      it "should return 3 unit" do
        expect(Unit.active.size).to eq 3
      end
    end
  end
end
