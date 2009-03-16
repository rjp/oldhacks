require 'erb'

# graph parameters
size = 300

offset = 0.05*size
width = 0.9*size
height = 0.4*size
scale = 65536 / height
midpoint = size - 1.1*height

max_vol = 65535

file = ARGV[0]
tracknum = ARGV[1]
trackname = ARGV[2]

class Bucket
    attr_accessor :total, :count, :min, :max
    def initialize
        @total = 0
        @count = 0
        @min = 0
        @max = 0
        @pos_total = 0
        @neg_total = 0
    end
    def add(x)
        @total = @total + x
        if x > 0 then
            @pos_total = @pos_total + x
        else
            @neg_total = @neg_total + x
        end
        @count = @count + 1
        if x > @max then @max = x; end
        if x < @min then @min = x; end
    end
    def avg
        if @count > 0 then
            return @pos_total / @count, @neg_total / @count
        else
            return 0, 0
        end
    end
end

buckets = Array.new(300) { Bucket.new }

# sox -v 0.9 /path/to/test.mp3 -b 16 -s -c 2 -t au -

puts "reading file ", Time.now
x = IO.read(file)
puts "unpacking file ", Time.now
type, dataloc, data = x.unpack("NNa*")
puts "type=#{type} dloc=#{dataloc}"
bytes = x[dataloc..-1].unpack('i*')
puts "bucketing samples, ", Time.now
bucket_size = bytes.size / width
p bytes.size
#test = bytes[0..441000]
#bytes = test
puts "#{bucket_size} samples in each bucket"
bytes.each_with_index { |i,j|
    left = i >> 16
    right = i & 0xFFFF
    bucket = j / bucket_size
#    if j % 44100 == 0 then puts "#{j/44100} b=#{bucket}"; end
    buckets[bucket].add(left)
}
puts "plotting graph ", Time.now
t_x = 0.1*size
t_y1 = midpoint + 0.6*height
t_y2 = midpoint + 0.7*height
title = "Sonogram of MONKEY BADGER"
template = File.read("output.erb")
tt = ERB.new(template, nil, '%')
$stderr.puts tt.result
puts Time.now
