module ScoutHelper
  def humanize(input)
    input.gsub('_', ' ').capitalize
  end

  def pit_namespace(str, number)
    'pit_data[team' + number.to_s + '[' + str + ']]'
  end

  def pit_checkbox_namespace(str, number)
    'pit_data[team' + number.to_s + '[' + str + '_check]]'
  end

  def selectify_string_id(sid, number)
    pit_namespace(sid + '_select', number)
  end

  def selectify_string_id_option(sid, opt, number)
    pit_namespace(sid + '_select' + '_' + opt, number)
  end
end
