class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string  :name
      t.string  :description

      t.string  :subject
      t.text    :body

      t.timestamps
    end

    add_index :email_templates, :name, :unique => true
  end

  def self.down
    drop_table :email_templates
  end
end