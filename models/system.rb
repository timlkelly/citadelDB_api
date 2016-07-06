class System < ActiveRecord::Base
  validates_presence_of :region, :system_id, :name

  belongs_to :regions

  def parse_csv
    CSV.foreach('./mapSolarSystems.csv', headers: true, header_converters: :symbol) do |row|
      System.create(region: row[0].to_i, system_id: row[2].to_i, name: row[3])
    end
  end
end