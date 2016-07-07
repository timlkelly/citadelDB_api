require 'spec_helper'
include WithRollback

describe 'Region model' do
  describe 'parse_csv' do
    context 'is given a csv file' do
      it 'adds to the database' do
        expect(Region.count).not_to be(0)
      end
    end
    context 'test region name' do
      it 'returns Derelik' do
        expect(Region.first.name).to eq('Derelik')
      end
    end
  end
end
