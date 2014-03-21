module SerializerHelpers
  def serialized(obj, serializer=nil)
    return '' if obj.nil?
    if serializer.nil?
      obj.active_model_serializer.new(obj).to_json
    else
      serializer.new(obj).to_json
    end
  end
end