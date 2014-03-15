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


# ----------------------------------------------------------------------------
# Create User
# ----------------------------------------------------------------------------

def create_user(email, username, name)
  user = User.create!(email: email, password: 'password', username: username, name: name, aboutme: 'Nothing to say!')

  print_content "created user: #{user.name}"
end


# ----------------------------------------------------------------------------
# Create Users
# ----------------------------------------------------------------------------

def create_users
  print_title('setting up default users')

  # create user admin
  admin = create_user 'admin@stacker.com', 'admin', 'Admin'
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
  print_title('importing transactions')

  File.open 'db/data/groups.txt', 'r' do |file|
    row = file.gets
    row.strip!
    names = row.split(',')
    uniqname, name = names[0].strip, names[1].strip

    user = User.find_by(username: 'liqi')

    group = user.groups.create!(uniqname: uniqname, name: name)
  # user.become_owner group
    user.add_role :owner, group
    group.users << (User.all - [user])

    print_content "created group: #{group.name}(#{group.users.count}) owned by #{group.owner.name}"
  end

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
      txn = Transaction.create!(user_id: user.id, action: action, amount: amount, operated_at: operated_at)
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

  owner = User.find_by(username: 'liqi')
  group = owner.owned_groups.first

  File.open 'db/data/activities.txt', 'r' do |file|
    while row = file.gets
      # import fees and fee_items
      row.strip!
      dates = row.split(',')
      started_at, stopped_at = dates[0].strip, dates[1].strip
      activity = Activity.create!(group_id: group.id, started_at: started_at, stopped_at: stopped_at)
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
        participant = Participant.create!(user_id: user.id, activity_id: activity.id, friend_number: 0, derated_pay: derated_pay)
        print_content "imported participant: #{participant.user.name} with derated_pay #{participant.derated_pay}", 2
      end

      # generate bill
      activity.generate_bill
    end
  end
  print_summary "total imported activities count: #{Activity.count}"
end


Transaction.destroy_all
Activity.destroy_all
Group.destroy_all
User.destroy_all
Role.destroy_all
import_users
#create_users
#create_groups
import_groups
import_transactions
import_activities
