class AddZonaHorariaToBanos < ActiveRecord::Migration
  def change
    add_column :banos, :zonaHoraria, :integer
  end
end
