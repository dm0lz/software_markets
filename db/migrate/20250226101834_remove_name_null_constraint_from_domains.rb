class RemoveNameNullConstraintFromDomains < ActiveRecord::Migration[8.0]
  def change
    change_column_null :domains, :name, true
  end
end
