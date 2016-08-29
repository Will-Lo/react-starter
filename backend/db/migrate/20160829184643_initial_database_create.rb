class InitialDatabaseCreate < ActiveRecord::Migration
  def change
	  create_table "students", force: :cascade do |t|
	    t.string   "name"
	    t.boolean "is_deleted"
	  end
  end
end
