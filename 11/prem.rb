require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'spread.so'
require 'gdbm'
require 'yaml'
require 'log4r'
include Log4r
require 'ftools'

$LOAD_PATH.push '/home/rjp/nb'
require 'format_array'

l4r = Logger.new 'football.log'
f = FileOutputter.new 'file', :filename => '/data/rjp/logs/football', :trunc => false
f.formatter = PatternFormatter.new :pattern => '%l [%d] %80M'
l4r.outputters = f

sp = Spread.new("4803", "football")

feeds = []
data = YAML.load_file('/data/rjp/football.yml')

data.sort_by{rand()}.each { |a|
    prefix, url = a
    xdir = "/home/rjp/nb/db/#{prefix}"
    File.makedirs xdir
    mygdbm = GDBM.new("#{xdir}/titles.db")
    feeds.push [prefix, url, xdir, prefix.upcase, mygdbm]
}
    
    doc = nil
    feeds.each { |feed|
        prefix, url, xdir, ucprefix, titles = feed
        l4r.info "#{prefix} #{url}"

	    olddata = ''
	
	    predoc = ''
	    retries = 10
	    begin
	        doc = Hpricot(open(url))
	    rescue Timeout::Error
	        retries = retries - 1
	        if retries > 0 then
	            sleep 30
	            retry
	        else
	            exit
	        end
	    end

	    sendable = []
	    doc.search('//table[@class="livescores"]/tr/comment()/..').each { |match| 
	        title = match.inner_text.strip.gsub(%r{[\n\t\r ]+}, ' ')
	
	        if titles[title].nil? then
	           titles[title] = '-'
	           sendable << title
               l4r.info sendable
	        end
	    }
	
	    if sendable.size > 0 then
            data = format_array(sendable, ucprefix)
            data.each { |line|
		        sp.multicast(line, 'sport_say', Spread::RELIABLE_MESS)
                    l4r.info data
            }
	        olddata = data
	    end
	    sleep 5*rand(3)
	}
