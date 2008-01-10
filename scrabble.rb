require 'rubygems'
require 'hpricot'
require 'open-uri'

game_id = 13386865

server = '74.54.87.124'
rand_val = rand()
game_url = %Q[http://#{server}/email_scrabble/xmlv3.php?showGameOver=&gid=#{game_id}&action=gameinfo&rnd=#{rand_val}]

def draw_board 
    0.upto(14) do |x|
        0.upto(14) do |y|
            fill rgb(1.0,1.0,1.0)
            stroke rgb(0.0,0.0,0.0)
            rect 34*x+17, 34*y+17, 34, 34
        end
    end
end

# doc = Hpricot.XML(open(game_url))
Shoes.app :height => 34*16, :width => 34*16 do

draw_board

doc = Hpricot.XML(open('endgame.xml'))
gi = {}
doc.search("/xml/gameinfo/*").each { |i|
    gi[i.name] = i.inner_text
}
moves = []
doc.search("/xml/movesnode/*").each { |i|
    if i.name =~ /^m(\d+)/ then
        move, player, word, score, type = i.inner_text.split(',')
        moves[move.to_i] = [gi[player], word, score, type]
    elsif i.name =~ /cnt/ then
        gi['movecount'] = i.inner_text.to_i
    end
}
nodes = []
doc.search("/xml/boardnode/nodeval") { |i|
    i.inner_text.split('|').each { |j|
        nodes.push j.split(',')
    }
}
node = 0
moves[1..-1].each_with_index { |j, move|
    player, word, score, type = j
    word.split('').each { |ch|
        letter,x,y,f = nodes[node]
        if letter == ch then
            node = node + 1
            xc = 34*y.to_i + 17
            yc = 34*x.to_i + 17
# puts "#{player} placed #{letter} at #{x},#{y}"
            if letter.upcase == letter then
                o = image "#{letter}.png", :left => xc, :top => yc
            else
                o = image "#{letter.upcase}.png", :left => xc, :top => yc
                nofill
                stroke rgb(0.0,0.0,0.0) 
                rect xc-2, yc-2, 34, 34
            end
        end
    }
}
end
