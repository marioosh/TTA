class CreateEmailLogs < ActiveRecord::Migration
  def self.up
    create_table :email_logs do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :email_template_id

      t.string  :subject
      t.text    :body

      t.timestamp :created_at
    end
  end

  def self.down
    drop_table :email_logs
  end
end
