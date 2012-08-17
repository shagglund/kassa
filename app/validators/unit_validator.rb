class UnitValidator < ActiveModel::Validator
  def validate(record)
    unless record.unit.to_sym.in? Unit.units
      record.errors[:unit] << I18n.t('unit.errors.invalid')
    end
  end
end