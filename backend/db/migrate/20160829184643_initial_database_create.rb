class InitialDatabaseCreate < ActiveRecord::Migration
  def change
	  create_table "students", force: :cascade do |t|
	    t.string   "name"
	  end
  end
end
