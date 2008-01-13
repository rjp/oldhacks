require 'rubygems'
require 'hpricot'
require 'open-uri'

$server = '74.54.87.124'
$squares = Array.new(15) {Array.new(15)}
$colors = {'p1'=>'white', 'p2'=>'green', 'p3'=>'blue','p4'=>'purple'}

def reset_board(tiles, squares)
    tiles.each_with_index { |i,x|
        i.each_with_index { |p,y|
            squares[x.to_i][y.to_i].path = "letters/#{p}.png"
            squares[x.to_i][y.to_i].show
        }
    }
end

def update_board(game_id, squares)
rand_val = rand()
game_url = %Q[http://#{$server}/email_scrabble/xmlv3.php?showGameOver=&gid=#{game_id}&action=gameinfo&rnd=#{rand_val}]
doc = Hpricot.XML(open(game_url)) # 'endgame.xml'))
gi = {}
doc.search("/xml/gameinfo/*").each { |i|
    gi[i.name] = i.inner_text
}
moves = []
doc.search("/xml/movesnode/*").each { |i|
    if i.name =~ /^m(\d+)/ then
        move, player, word, score, type = i.inner_text.split(',')
        moves[move.to_i] = [gi[player], word, score, type, player]
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
    player, word, score, type, player_id = j
    color = $colors[player_id]
    word.split('').each { |ch|
        letter,x,y,f = nodes[node]
        if letter == ch then
            node = node + 1
#            if letter.upcase == letter then
            squares[x.to_i][y.to_i].path = "letters/#{color}#{letter}.png"
            squares[x.to_i][y.to_i].show
#            else
#            end
        end
    }
}
end

# doc = Hpricot.XML(open(game_url))
Shoes.app :height => 32*16+8, :width => 32*15+5 do
    tiles = Array.new(15) {Array.new(15,'white')}
    { 
        'red' => [[0,0],[0,7],[0,14],[7,0]],
        'aquamarine' => [[0,3],[3,0],[2,6],[6,2],[7,3],[6,6]],
        'blue' => [[1,5],[5,1],[5,5]],
        'pink' => [[1,1],[2,2],[3,3],[4,4],[7,7]]
    }.each { |k,v|
        v.each { |x,y|
            rx,ry = 14-x,14-y
            tiles[x][y] = k
            tiles[y][x] = k
            tiles[rx][ry] = k
            tiles[ry][rx] = k
            tiles[rx][y] = k
            tiles[x][ry] = k
        }
    }
    
stack :margin => 10 do
    flow do
        game_id = edit_line :text => '14065630'
        button "Display" do
            reset_board tiles, $squares
            update_board game_id.text, $squares
            nofill
            fill rgb(1.0,1.0,1.0)
        end
    end
end

tiles.each_with_index { |i,x|
    stack :width => 15*32 do
        flow do
	        i.each_with_index { |p,y|
	            $squares[x.to_i][y.to_i] = image "letters/#{p}.png"
	        }
        end
    end
}
end
