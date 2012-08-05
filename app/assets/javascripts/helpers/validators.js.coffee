class Kassa.Validators

  positive: (errors, record, key, callback)->
    errors.add("#{key} cannot be negative or zero") unless record > 0
    callback()
    return