class Province < ActiveRecord::Base
  has_many :cities, primary_key: 'code', foreign_key: 'province_code'
end
