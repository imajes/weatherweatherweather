module ApplicationHelper

  # NOTE: I'm sure there's an algorithmic way to do this, but sometimes a
  # case statement does the job just fine.
  def direction_as_cardinal(degrees)
    case degrees.to_f
    when 0...11.25 then "North"
    when 11.25...33.75 then "North North East"
    when 33.75...56.25 then "North East"
    when 56.25...78.75 then "East North East"
    when 78.75...101.25 then "East"
    when 101.25...123.75 then "East South East"
    when 123.75...146.25 then "South East"
    when 146.25...168.75 then "South South East"
    when 168.75...191.25 then "South"
    when 191.25...213.75 then "South South West"
    when 213.75...236.25 then "South West"
    when 236.25...258.75 then "West South West"
    when 258.75...281.25 then "West"
    when 281.25...303.75 then "West North West"
    when 303.75...326.25 then "North West"
    when 326.25...348.75 then "North North West"
    end
  end

  def time_of_day(daylight)
    if daylight
      "day time"
    else
      "night time"
    end

  end

end
