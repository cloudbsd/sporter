# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# ----------------------------------------------------------------------------
# Print Methods
# ----------------------------------------------------------------------------

def print_title(title)
  puts "\n== #{title}"
end

def print_summary(content)
  puts "== #{content}"
end

def print_content(content, level = 1)
  indent = ' ' * (3 * level)
  puts "#{indent}=> #{content}"
end


# data line format:
#   insert Data_Province values(199,'110000','Beijing')
def import_provinces
  Province.destroy_all
  print_title('importing provinces')
  File.open 'db/data/1_sql_insert_province.sql', 'r' do |file|
    while row = file.gets
      row.strip!
      columns = /.+\(\d+,'(\d+)','(.+)'\)/.match(row)
      code = columns[1]
      name = columns[2]
      province = Province.create(code: code, name: name)
      print_content "imported province: #{province.id}, #{province.code}, #{province.name}"
    end
  end
  print_summary "total imported provinces count: #{Province.count}"
end

# data line format:
#   insert Data_City values(1,'110100','Beijing','110000')
#   insert Data_City values(3,'120100','Tianjing','120000')
def import_cities
  City.destroy_all
  print_title('importing cities')
  File.open 'db/data/2_sql_insert_city.sql', 'r' do |file|
    while row = file.gets
      row.strip!
      columns = /.+\(\d+,'(\d+)','(.+)','(\d+)'\)/.match(row)
      code = columns[1]
      name = columns[2]
      province_code = columns[3]
      city = City.create(code: code, name: name, province_code: province_code)
      print_content "imported city: #{city.id}, #{city.code}, #{city.name}, #{city.province_code}"
    end
  end
  print_summary "total imported cities count: #{City.count}"
end

# data line format:
#   insert Data_Area values(1,'110101','东城区','110100')
#   insert Data_Area values(2,'110102','西城区','110100')
def import_districts
  District.destroy_all
  print_title('importing districts')
  File.open 'db/data/3_sql_insert_district.sql', 'r' do |file|
    while row = file.gets
      row.strip!
      columns = /.+\(\d+,'(\d+)','(.+)','(\d+)'\)/.match(row)
      code = columns[1]
      name = columns[2]
      city_code = columns[3]
      district = District.create(code: code, name: name, city_code: city_code)
      print_content "imported district: #{district.id}, #{district.code}, #{district.name}, #{district.city_code}"
    end
  end
  print_summary "total imported districts count: #{District.count}"
end


# ----------------------------------------------------------------------------
# Create User
# ----------------------------------------------------------------------------

def create_user(email, username, name)
  user = User.create!(email: email, password: 'password', username: username, name: name, aboutme: 'Nothing to say!')
  gravatar = format "user%03d.jpg", user.id%29+1
  user.update(gravatar: gravatar)

  print_content "created user: #{user.name}"
end


# ----------------------------------------------------------------------------
# Create Users
# ----------------------------------------------------------------------------

def create_users
  print_title('setting up default users')

  # create user admin
  admin = create_user 'admin@stacker.com', 'admin', 'Admin'
  admin.add_role :admin
# moderator = create_user 'moderator@stacker.com', 'moderator', 'Moderator'
# liqi = create_user 'liqi@stacker.com', 'liqi', 'Li Qi'

# 10.times do |i|
#   email = Faker::Internet.email
#   name = Faker::Name.name
#   username = "user#{i}"
#   create_user(email, username, name)
# end

  puts "== Total #{User.count} users are created"
end

def import_users
  print_title('importing users')
  File.open 'db/data/users.txt', 'r' do |file|
    while row = file.gets
      row.strip!
      names = row.split(',')
      name, username, email = names[0], names[1], "#{names[1]}@sporter.com"
      create_user(email, username, name)
    end
  end
  print_summary "total imported user count: #{User.count}"
end


# ----------------------------------------------------------------------------
# Create Group
# ----------------------------------------------------------------------------

def create_group(user)
  group = user.groups.create!(name: "Group #{user.name}")
# user.become_owner group
  user.add_role :owner, group

  print_content "created group: #{group.name}"

  group
end

def create_groups
  all_users = User.all
  all_users.each do |user|
    group = create_group(user)
    users = (User.all - [user]).sample(5)
    group.users << users
  end
end


def import_groups
  print_title('importing groups')

  File.open 'db/data/groups.txt', 'r' do |file|
    while row = file.gets
      # import group info
    # row = file.gets
      row.strip!
      names = row.split(',')
      username, uniqname, name, pay_type, province_name, city_name, district_name, location = names[0].strip, names[1].strip, names[2].strip, names[3].strip, names[4].strip, names[5].strip, names[6].strip, names[7].strip
      user = User.find_by(username: username)
      province = Province.find_by name: province_name
      city = City.find_by name: city_name
      district = District.find_by name: district_name
      group = user.groups.create!(uniqname: uniqname, name: name, pay_type: pay_type, province: province.code, city: city.code, district: district.code, location: location)
      user.become_owner group

      # members
      row = file.gets
      row.strip!
      names = row.split(',')
      names.each do |name|
        user = User.find_by(name: name.strip)
        group.add_member user
        print_content "import user #{user.name} into group: #{group.name}"
      end

      print_content "created group: #{group.name}(#{group.users.count}) owned by #{group.owner.name}"
    end
  end

end


def import_card_types
  print_title('importing card types')

  File.open 'db/data/card_types.txt', 'r' do |file|
    while row = file.gets
      row.strip!
      names = row.split(',')
      name, group_id, price, duration, number, type = names[0].strip, names[1].strip, names[2].strip, names[3].strip, names[4].strip, names[5].strip
      card_type = CardType.create!(group_id: group_id, name: name, kind: type, price: price, duration: duration, number: number)
      print_content "created card type: #{card_type.name}"
    end
  end

  print_summary "total imported card types count: #{CardType.count}"
end


# ----------------------------------------------------------------------------
# import transactions
# ----------------------------------------------------------------------------

def import_transactions
  print_title('importing transactions')

  File.open 'db/data/transactions.txt', 'r' do |file|
    while row = file.gets
      row.strip!
      names = row.split(',')
      name, action, amount, operated_at = names[0].strip, names[1].strip, names[2].strip.to_f, names[3].strip
      user = User.find_by(name: name)
      card = user.find_or_create_debit_card! 1
      txn = Transaction.create!(user_id: user.id, card_id: card.id, action: action, amount: amount, operated_at: operated_at)
      print_content "imported transaction: #{txn.user.name} #{txn.action} #{txn.amount}"
    end
  end
  print_summary "total imported transaction count: #{Transaction.count}"
end


# ----------------------------------------------------------------------------
# import activities
# ----------------------------------------------------------------------------

def import_activities
  print_title('importing activities')

# owner = User.find_by(username: 'liqi')
# group = owner.owned_groups.first

  File.open 'db/data/activities.txt', 'r' do |file|
    while row = file.gets
      # import fees and fee_items
      row.strip!
      dates = row.split(',')
      uniqname, started_at, stopped_at = dates[0].strip, dates[1].strip, dates[2].strip
      applied_at = started_at.to_datetime - 1.hour
      group = Group.find_by uniqname: uniqname
      owner = group.owner
      activity = Activity.create!(group_id: group.id, started_at: started_at, stopped_at: stopped_at, applied_at: applied_at, pay_type: group.pay_type, number_limit: 30)
      print_content "imported activity: from #{activity.started_at} to #{activity.stopped_at}"

      # import fees and fee_items
      row = file.gets
      fee_pairs = row.split(',')
      fee_pairs.each do |fee_pair|
        items = fee_pair.split('-')
        fee_name, price = items[0].strip, items[1].strip
        fee = Fee.find_or_create_by!(name: fee_name, user_id: owner.id, group_id: group.id)
        fee_item = FeeItem.create!(activity_id: activity.id, fee_id: fee.id, price: price)
        print_content "imported fee items: from #{fee_item.fee.name} to #{fee_item.price}", 2
      end

      # import participants
      row = file.gets
      pant_pairs = row.split(',')
      pant_pairs.each do |pant_pair|
        items = pant_pair.split('-')
        name, derated_pay = items[0].strip, items[1].strip
        user = User.find_by(name: name)
        card = user.find_or_create_debit_card! 1
        participant = Participant.create!(user_id: user.id, card_id: card.id, activity_id: activity.id, friend_number: 0, derated_pay: derated_pay)
        print_content "imported participant: #{participant.user.name} with derated_pay #{participant.derated_pay}", 2
      end

      # generate bill
      activity.generate_bill
    end
  end
  print_summary "total imported activities count: #{Activity.count}"
end

def import_activities_card
  print_title('importing activities pay with card')

# owner = User.find_by(username: 'liqi')
# group = owner.owned_groups.first

  File.open 'db/data/activities_card.txt', 'r' do |file|
    while row = file.gets
      # import fees and fee_items
      row.strip!
      dates = row.split(',')
      uniqname, started_at, stopped_at = dates[0].strip, dates[1].strip, dates[2].strip
      applied_at = started_at.to_datetime - 1.hour
      group = Group.find_by uniqname: uniqname
      owner = group.owner
      activity = Activity.create!(group_id: group.id, started_at: started_at, stopped_at: stopped_at, applied_at: applied_at, pay_type: group.pay_type, number_limit: 30)
      print_content "imported activity: from #{activity.started_at} to #{activity.stopped_at}"

      # import participants
      users = group.users.sample(5)
      users.each do |user|
        if user.cards.number_cards(group.id).empty?
          card_type = group.card_types.where(kind: 'number').sample
          card = user.cards.create!(card_type_id: card_type.id, started_at: Date.today, stopped_at: Date.today+90, balance: card_type.number)
        else
          card = user.cards.number_cards(group.id).first
        end
        participant = Participant.create!(user_id: user.id, card_id: card.id, activity_id: activity.id, friend_number: 0, derated_pay: 0)
      end

      # generate bill
      activity.generate_bill
    end
  end
  print_summary "total imported activities count: #{Activity.count}"
end


CardType.destroy_all
Transaction.destroy_all
Activity.destroy_all
Group.destroy_all
User.destroy_all
Role.destroy_all
import_provinces
import_cities
import_districts
create_users
import_users
#create_groups
import_groups
import_card_types
import_transactions
import_activities
import_activities_card
