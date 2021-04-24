class ChangeUserForSubscription < ActiveRecord::Migration[6.1]
  def change
    change_column_null :subscriptions, :user_id, true
  end
end
