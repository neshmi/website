require 'spec_helper'

describe Location do
  describe '.new_from_meetup' do
    it 'creates an object using attributes from a request' do
      request = OpenStruct.new(venue: OpenStruct.new(name: 'Awesome Building', address_1: '1234 five way'))
      event = Event.new_from_meetup(request)
      event.location.name.should == 'Awesome Building'
      event.location.address.should == '1234 five way'
    end
  end
end