require 'rails_helper'

RSpec.describe Event, type: :model do

  let(:valid_attributes) {
    {
      "name":"test_name",
      "description":"test description",
      "start":"2015-10-17",
      "end":"2015-10-27",
      "number_of_days":10,
      "location":"location test",
      "published":true,
    }
  }
  let(:invalid_attributes) {
    attrs = valid_attributes.dup
    attrs.delete(:name)
    attrs.delete(:end)
    attrs.delete(:number_of_days)
    attrs.delete(:name)
    attrs
  }
  context "creating an event" do
    describe "with all valid attributes" do
      it "should be able to save" do
        event = Event.new(valid_attributes)
        expect(event.save).to be
      end
    end

    describe "with invalid attributes" do
      it "should not be able to save" do
        event = Event.new(invalid_attributes)
        expect(event.save).to_not be
      end
    end

    describe "without number_of_days" do
      it "should be able to save and number_of_days have the correct values" do
        valid_attributes.delete(:number_of_days)
        event = Event.new(valid_attributes)
        expect(event.save).to be
        expect(event.number_of_days).to eq(10)
      end
    end

    describe "without number_of_days" do
      it "should not be able to save" do
        valid_attributes.delete(:number_of_days)
        event = Event.new(valid_attributes)
        expect(event.save).to be
        expect(event.number_of_days).to eq(10)
      end
    end
  end
end
