require 'spec_helper'
include WithRollback

describe 'Killmail model' do
  describe 'killmail_data' do
    context 'with package' do
      let(:killmail_fixture) { { package: { 'killID' => 22 } } }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns data' do
        expect(killmail.killmail_data['killID']).to eq(22)
      end
    end
    context 'without package' do
      let(:killmail_fixture) { { 'killID' => 22 } }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns data' do
        expect(killmail.killmail_data['killID']).to eq(22)
      end
    end
  end

  describe 'check_if_citadel' do
    context 'Astrahus killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Astrahus deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Fortizar killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/fortizar_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Fortizar deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/fortizar_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Keepstar killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/keepstar_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Keepstar deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/keepstar_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'upwell killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/upwell_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'upwell deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/upwell_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'is not a citadel' do
      let(:killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel?).to eq false
      end
    end
  end

  describe 'generate_citadel_hash' do
    context 'with a valid killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: 'E8-YS9',
          citadel_type: 'Astrahus',
          corporation: 'Forge Industrial Command',
          alliance: 'FUBAR.',
          killed_at: nil
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
    context 'with a valid deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: 'Jaschercis',
          citadel_type: 'Astrahus',
          corporation: 'Tokenada Technical Enterprises',
          alliance: nil,
          kill_at: '2016.06.29 03:26:16'
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
  end

  describe 'citadel_exists?' do
    context 'citadel is already recorded' do
      it 'returns true' do
      end
    end
    context 'citadel is not in db' do
      it 'returns false' do
      end
    end

  end

  it 'checks if the generated data matches any existing citadels'

  it 'additional kills by same citadel are associated correctly'

  it 'additional relevant killmail does not add to Citadel db'
end
