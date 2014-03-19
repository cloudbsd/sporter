class City < ActiveRecord::Base
  belongs_to :province, primary_key: 'code', foreign_key: 'province_code'
  has_many :districts, primary_key: 'code', foreign_key: 'city_code'
end
