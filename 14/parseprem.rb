require 'rubygems'
require 'hpricot'

# takes a Hpricot doc
def parse_all(doc)
    bookings = []
	matches = Hash.new {|h,k| h[k] = []}
    match_date = nil
    previous_date = nil
    doc.search('//table[@class="competitionResults"]/tr/td[@class="c1"]').each { |match| 
        title = match.parent.to_plain_text

        x = title.gsub(%r{\[.+?\](\n|$)}, "").gsub(%r{\n\S+.+\(.+?(\n |$)},"").gsub(%r{\s+}, " ").strip

        title =  x

        d = match.parent.parent.previous_sibling.previous_sibling.search('/b')

        if d.nil? or d[0].nil? then 
            match_date = previous_date
        elsif d[0].name == 'b' then
            match_date = d.inner_text
            previous_date = match_date
        end
        matches[match_date].push title
        data = match.search('../tr')
        scores = Array.new(95) {Array.new(2,0)}
      
        bk = data[2] 

        if not data[1].nil? and data[1].inner_text !~ /Bookings/ then
            hgl = data[1].at('/td[@class="c1"]')
            if hgl and not hgl.children.nil? then
                hgl.children.select{|e| e.text?}.each { |s|
                    s.inner_text =~ / (\d+)$/
                    ko = $1
                    ko.to_i.upto(90) {|z|
                        scores[z][0] = scores[z][0] + 1
                    }
                }
            end
            hgl = nil
            unless data[1].nil? then
                hgl = data[1].at('/td[@class="c3"]')
            end
            if not hgl.nil? and not hgl.children.nil? then
                hgl.children.select{|e| e.text?}.each { |s|
                    s.inner_text =~ / (\d+)$/
                    ko = $1
                    ko.to_i.upto(90) {|z|
                        scores[z][1] = scores[z][1] + 1
                    }
                }
            end
        else
            bk = data[1]
        end


        if bk.nil? then
        else 
            hgl = bk.at('/td[@class="c1"]')
            if hgl and not hgl.children.nil? then
	        # these should go into an array within the match record
                hgl.children.select{|e| e.text?}.each { |s|
                    s.inner_text =~ / (\d+)$/
                    ko = $1.to_i
                    if scores[ko][0] > scores[ko][1] then
                        bookings.push "#{ko} win"
                    elsif scores[ko][0] == scores[ko][1] then
                        bookings.push "#{ko} draw"
                    else
                        bookings.push "#{ko} lose"
                    end
                }
            end
            hgl = nil
            unless data[1].nil? then
                hgl = data[1].at('/td[@class="c3"]')
            end
            if not hgl.nil? and not hgl.children.nil? then
                hgl.children.select{|e| e.text?}.each { |s|
                    s.inner_text =~ / (\d+)$/
                    ko = $1.to_i
                    if scores[ko][0] > scores[ko][1] then
                        bookings.push "#{ko} win"
                    elsif scores[ko][0] == scores[ko][1] then
                        bookings.push "#{ko} draw"
                    else
                        bookings.push "#{ko} lose"
                    end
                }
            end
        end
	}
    return matches, bookings
end

def parse_file(filename)
    doc = open(filename) { |f| Hpricot f, :fixup_tags => true }
	return parse_all(doc)
end

