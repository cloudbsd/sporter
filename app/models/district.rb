class District < ActiveRecord::Base
  belongs_to :city, primary_key: 'code', foreign_key: 'city_code'
end
