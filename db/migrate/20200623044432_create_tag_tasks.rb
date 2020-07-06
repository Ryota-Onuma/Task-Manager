# frozen_string_literal: true

class CreateTagTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_tasks do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
