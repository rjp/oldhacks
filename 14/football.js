function init() {
    var svg = document.getElementById("plotpos");
}

var last_c;
var last_col;

function hilite(c) {
    if (last_c) {
        var xp = document.getElementsByClassName(last_c);
	    for (y in xp) {
	        if (xp[y].nodeName == 'path') {
                xp[y].setAttribute('stroke', last_col);
	            xp[y].setAttribute('stroke-width', '1px');
	        }
	        if (xp[y].nodeName == 'text') {
	            xp[y].setAttribute('fill', last_col);
	            xp[y].setAttribute('font-style', 'normal');
	        } 
	    }
    }
    if (last_c == c) {
        last_c = '';
        return;
    }
    last_c = c;
    var lp = document.getElementsByClassName(c);
    for (y in lp) {
        if (lp[y].nodeName == 'path') {
            last_col = lp[y].getAttribute('stroke');
            lp[y].setAttribute('stroke', '#F00');
            lp[y].setAttribute('stroke-width', '3px');
        } 
        if (lp[y].nodeName == 'text') {
            lp[y].setAttribute('fill', '#F00');
            lp[y].setAttribute('font-style', 'italic');
        } 

    }
}
