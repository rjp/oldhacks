YEAR=0809
LGE=prem
OHTML=~/public_html/tmp/fg/${LGE}/${YEAR}
PPFX=${LGE}/${YEAR}
OPFX=data/${LGE}/${YEAR}

mkdir -p data/${LGE} -p history/${LGE}/${YEAR} $OHTML

#wget -O $OPFX.html http://news.bbc.co.uk/sport1/hi/football/eng_prem/results/default.stm
#wget -O tmp.html http://news.bbc.co.uk/sport1/hi/football/eng_prem/results/default.stm
#awk '!(/^[ \t]*<\/tr>$/ && a~/<\/tr>$/){print}{a=$0}' < tmp.html > $OPFX.html

if [ ! -e ${OPFX}_teams.yaml ]; then
    echo "You have no teams file, trying to generate one from the results"
    lynx -dump $OPFX.html | grep '(HT' | cut -d']' -f2 | sort -u | sed -e 's/ /_/g' -e 's/^/- /' > ${OPFX}_teams.yaml
    teams=$(wc -l < ${OPFX}_teams.yaml)
    if [ $teams < 20 ]; then
        echo "Only found $teams teams in results, please fix up ${OPFX}_teams.yaml by hand"
        exit
    fi
fi

ruby preparse.rb $OPFX.html $OPFX.yaml 2> weekly/$PPFX/parse
LEAGUE=$OPFX.yaml PREFIX=$PPFX ./driver.sh
HTML=1 ruby showfinal.rb history/$PPFX/* > $OHTML/test.xhtml
rsync -Cavz svg/$PPFX/ $OHTML/
# PREFIX=$PPFX ./montage.sh
# rsync -Cavz png/$PPFX/ $OHTML/
