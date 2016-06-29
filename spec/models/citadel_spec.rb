require 'spec_helper'
include WithRollback

describe 'Citadel model' do
  let(:valid_attributes) do 
    { 
      system: 'Y-4CFK',
      nearest_celestial: '6NJ stargate',
      citadel_type: 'Astrahus',
      corporation: 'TMLK'
    }
  end

  it 'creates a new instance' do
    temporarily do  
      expect do
        Citadel.create(valid_attributes)
      end.to change(Citadel, :count).by 1
    end
  end

  it 'can be found in the database' do
    temporarily do
      Citadel.all.map(&:destroy)  
      expect(Citadel.count).to eq(0)
      Citadel.create(valid_attributes)
      expect(Citadel.find_by(system: 'Y-4CFK')).to be_present
    end
  end
end
