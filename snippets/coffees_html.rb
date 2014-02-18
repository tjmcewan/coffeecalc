def coffees_html
  $coffees.map { |coffee|
    "<div>#{ coffee[:what] } $#{ coffee[:cost] }</div>"
  }.join("<br>")
end
