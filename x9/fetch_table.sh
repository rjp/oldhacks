lynx -nolist -dump http://news.bbc.co.uk/sport1/hi/football/eng_prem/table/default.stm | sed -e '1,/PTS/d' -e '/tbl_spc/,$d' -e '/___/d' -e '/^$/d' -e 's/\([a-z]\) \([A-Z]\)/\1_\2/'
