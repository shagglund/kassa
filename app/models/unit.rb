class Unit
  cattr_reader :units
  @@units = [:ml, :cl, :dl, :l, :piece].freeze

  def self.localized_units
    [[I18n.t('unit.ml').titlecase,:ml],
     [I18n.t('unit.cl').titlecase,:cl],
     [I18n.t('unit.dl').titlecase, :dl],
     [I18n.t('unit.l').titlecase,:l],
     [I18n.t('unit.piece').titlecase,:piece]]
  end
end