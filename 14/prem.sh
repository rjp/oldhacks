YEAR=0809
LGE=prem
OHTML=~/public_html/tmp/fg/${LGE}/${YEAR}
PPFX=${LGE}/${YEAR}
OPFX=data/${LGE}/${YEAR}

mkdir -p data/${LGE} -p history/${LGE}/${YEAR} $OHTML

# wget -O $OPFX.html http://news.bbc.co.uk/sport1/hi/football/eng_prem/results/default.stm
ruby preparse.rb $OPFX.html $OPFX.yaml
LEAGUE=$OPFX.yaml PREFIX=$PPFX ./driver.sh
HTML=1 ruby showfinal.rb history/$PPFX/* > $OHTML/test.xhtml
rsync -Cavz svg/$PPFX/ $OHTML/
# PREFIX=$PPFX ./montage.sh
# rsync -Cavz png/$PPFX/ $OHTML/
