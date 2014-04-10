class CreateBanos < ActiveRecord::Migration
  def change
    create_table :banos do |t|
      t.string :descripcion
      t.float :latitud
      t.float :longitud

      t.timestamps
    end
  end
end
