json.balance_changes do
  json.cache! cache_key_for_balance_changes(@balance_changes) do
    json.array! @balance_changes do |balance_change|
      json.cache! ['balance_change', balance_change.id] do
        json.id balance_change.id
        json.doer_id balance_change.doer_id
        json.change_note balance_change.change_note
        json.old_balance balance_change.old_balance
        json.new_balance balance_change.new_balance
        json.change balance_change.balance_change
        json.created_at balance_change.created_at
      end
    end
  end
end
json.doers do
  json.partial! 'users/list', users: @doers
end