require 'rubygems'
require 'hpricot'

# takes a Hpricot doc
def parse_all(doc)
	matches = []
    doc.search('//table[@class="livescores"]/tr/comment()/..').each { |match| 
#        title = match.inner_text.strip.gsub(%r{[\n\t\r ]+}, ' ')
#		matches.push title
	}
end

def parse_file(filename)
	doc = Hpricot(open(filename))
	return parse_all(doc)
end

