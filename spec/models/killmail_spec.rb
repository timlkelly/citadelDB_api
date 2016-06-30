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
          nearest_celestial_y_s: -3528973131527.2695,
          nearest_celestial_x_s: 1455528965291.3196,
          nearest_celestial_z_s: -307958392850.36145,
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
          nearest_celestial_y_s: 116721448927.0,
          nearest_celestial_x_s: -808460360514.0,
          nearest_celestial_z_s: -615629639132.0,
          citadel_type: 'Astrahus',
          corporation: 'Tokenada Technical Enterprises',
          alliance: nil,
          killed_at: '2016.06.29 03:26:16'
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
  end

  describe 'find_or_create_citadel' do
    let(:citadel_hash) do
      {
        system: 'E8-YS9',
        nearest_celestial_y_s: -3528973131527.2695,
        nearest_celestial_x_s: 1455528965291.3196,
        nearest_celestial_z_s: -307958392850.36145,
        citadel_type: 'Astrahus',
        corporation: 'Forge Industrial Command',
        alliance: 'FUBAR.',
        killed_at: nil
      }
    end
    let(:killmail) { Killmail.new }
    context 'citadel does not exist' do
      it 'creates a citadel instance' do
        temporarily do
          allow(killmail).to receive(:generate_citadel_hash) { citadel_hash }
          citadel = killmail.find_or_create_citadel
          expect(citadel.system).to eq('E8-YS9')
          expect(citadel.nearest_celestial_y).to eq(BigDecimal.new('-3528973131527.2695'))
          expect(citadel.nearest_celestial_x).to eq(BigDecimal.new('1455528965291.3196'))
          expect(citadel.nearest_celestial_z).to eq(BigDecimal.new('-307958392850.36145'))
          expect(citadel.citadel_type).to eq('Astrahus')
          expect(citadel.corporation).to eq('Forge Industrial Command')
          expect(citadel.alliance).to eq('FUBAR.')
          expect(citadel.killed_at).to eq(nil)
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'citadel already exists' do
      it 'it does not create duplicate instance' do
        temporarily do
          allow(killmail).to receive(:generate_citadel_hash) { citadel_hash }
          Citadel.create(citadel_hash)
          expect do
            citadel = killmail.find_or_create_citadel
            expect(citadel.system).to eq('E8-YS9')
            expect(citadel.nearest_celestial_y).to eq(BigDecimal.new('-3528973131527.2695'))
            expect(citadel.nearest_celestial_x).to eq(BigDecimal.new('1455528965291.3196'))
            expect(citadel.nearest_celestial_z).to eq(BigDecimal.new('-307958392850.36145'))
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Forge Industrial Command')
            expect(citadel.alliance).to eq('FUBAR.')
            expect(citadel.killed_at).to eq(nil)
          end.to change(Citadel, :count).by 0
          expect(Citadel.count).to eq(1)
        end
      end
    end
  end

  describe 'save_if_relevant' do
    let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:ship_killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'new killmail' do
      it 'saves to db' do
        temporarily do
          citadel = killmail.find_or_create_citadel
          killmail.save_if_relevant
          expect(killmail.citadel_id).to eq(citadel.id)
          expect(killmail.killmail_id).to eq(killmail.killmail_data['killID'])
          expect(killmail.killmail_json).to eq(killmail.killmail_json)
        end
      end
      context 'duplicate killmail' do
        it 'does not save' do
          temporarily do
            killmail.save_if_relevant
            killmail2.save_if_relevant
            expect(Killmail.count).to eq(1)
          end
        end
      end
      context 'not relevant report' do
        let(:ship_killmail) { Killmail.new(killmail_json: ship_killmail_fixture) }
        it 'does not save' do
          temporarily do
            expect do
              expect(ship_killmail.save_if_relevant).to be_falsey
            end.to change(Killmail, :count).by 0
          end
        end
      end
    end
  end
end
