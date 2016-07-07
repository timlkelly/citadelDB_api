require 'spec_helper'
include WithRollback

describe 'System model' do
  describe 'parse_csv' do
    context 'is given a csv file' do
      it 'adds to the database' do
        expect(System.count).not_to be(0)
      end
    end
    context 'test system name' do
      it 'returns Tanoo' do
        expect(System.first.name).to eq('Tanoo')
      end
    end
  end
end
