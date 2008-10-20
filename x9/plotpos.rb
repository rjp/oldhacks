require 'yaml'

infohash = YAML.load(File.new(ARGV[0]))
title = infohash['title']

puts <<HEADER
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="4cm" height="4cm" viewBox="0 0 400 400"
  xmlns="http://www.w3.org/2000/svg" version="1.1">
<title>#{title}</title>
<desc>League Positions vs Games Played</desc>
<rect x="1" y="1" width="398" height="398" fill="none" stroke="blue" />
HEADER
