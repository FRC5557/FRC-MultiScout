module TeamsHelper
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
end
