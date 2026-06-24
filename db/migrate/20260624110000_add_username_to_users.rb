class AddUsernameToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :username, :string

    User.reset_column_information
    User.find_each do |user|
      base_username = user.email.to_s.split("@").first.presence || "uzytkownik"
      candidate = base_username.parameterize(separator: "_").presence || "uzytkownik"
      suffix = 1

      while User.where.not(id: user.id).exists?(username: candidate)
        suffix += 1
        candidate = "#{base_username.parameterize(separator: "_").presence || 'uzytkownik'}_#{suffix}"
      end

      user.update_columns(username: candidate)
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
  end
end
