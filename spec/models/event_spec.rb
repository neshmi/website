require 'spec_helper'

describe Event do
  let(:event){ create(:event) }

  it "fails validation with no title" do
    Event.new.should have(1).error_on(:title)
  end
  it "passes validation with a title" do
    Event.new(:title => "liquid nitrogen").should have(:no).errors_on(:title)
  end

  it "fails validation with no date" do
    Event.new.should have(1).error_on(:date)
  end
  it "passes validation with a date" do
    Event.new(:date => DateTime.now).should have(:no).errors_on(:date)
  end

  it 'has people' do
    person = create(:person)
    person.events << event
    event.people.should include(person)
  end
end