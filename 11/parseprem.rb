require 'rubygems'
require 'hpricot'

# takes a Hpricot doc
def parse_all(doc)
	matches = Hash.new {|h,k| h[k] = []}
    match_date = nil
    doc.search('//table[@class="competitionResults"]/tr/comment()/..').each { |match| 
        title = match.inner_text.strip.gsub(%r{[\n\t\r ]+}, ' ')
        d = match.parent.previous_sibling.previous_sibling
        if d.nil? then 
            puts "no previous sibling sibling for #{title}"
            exit
        elsif d.name == 'b' then
            match_date = d.inner_text
        end
        matches[match_date].push title
	}
    return matches
end

def parse_file(filename)
    doc = open(filename) { |f| Hpricot f, :fixup_tags => true }
	return parse_all(doc)
end

