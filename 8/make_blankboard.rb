    tiles = Array.new(15) {Array.new(15,'grey90')}
    { 
        'red' => [[0,0],[0,7],[0,14],[7,0]],
        'skyblue' => [[0,3],[3,0],[2,6],[6,2],[7,3],[6,6]],
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
    
tiles.each_with_index { |i,x|
	        i.each_with_index { |p,y|
                puts "#{tiles[x.to_i][y.to_i]}.png"
	        }
}
