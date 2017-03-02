module ScoutHelper
  def stage_name(comp_level)
    case comp_level
    when 3
      'Quarterfinals'
    when 5
      'Finals'
    when 1
      'Qualification'
    when 2
      'Eight-finals'
    when 4
      'Semifinals'
    end
  end

  def match_namespace(str, mid)
    'match_data[match' + mid + '[' + str + ']]'
  end

  def match_checkbox_namespace(str, mid)
    'match_data[match' + mid + '[' + str + '_check]]'
  end

  def match_counter_namespace(str, mid)
    'match_data[match' + mid + '[' + str + '_counter]]'
  end

  def match_selectify_string_id(sid, mid)
    match_namespace(sid + '_select', mid)
  end

  def match_selectify_string_id_option(sid, opt, mid)
    match_namespace(sid + '_select' + '_' + opt, mid)
  end

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
