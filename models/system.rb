class System < ActiveRecord::Base
  validates_presence_of :region_eveid, :eveid, :name

  belongs_to :region, primary_key: :eveid, foreign_key: :region_eveid
  has_many :citadels

  def parse_csv(csv_filename = nil)
    csv_filename ||= './lib/mapSolarSystems.csv'
    CSV.foreach(csv_filename, headers: true, header_converters: :symbol) do |row|
      System.create(region_eveid: row[0].to_i, eveid: row[2].to_i, name: row[3])
    end
  end
end
