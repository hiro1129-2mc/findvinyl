class CreateMatrixNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :matrix_numbers do |t|
      t.string :number, null: false
    end
  end
end
