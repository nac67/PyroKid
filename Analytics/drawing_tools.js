var DrawingTools = {
    draw_rect : function (x,y,w,h,color) {
        context.fillStyle = color;
        context.strokeStyle = "#CCCCCC"
        context.fillRect(x,y,w,h);
        context.strokeRect(x,y,w,h)
    },

    //given a number and a max, give a color to represent heat
    get_heat : function (num,max_num) {
        var proportion = num/max_num;

        // change range from [0,1] to instead 0||[.1,1]
        // where if they die at all, it is .1 or greater
        // if they didn't die, it is 0
        if(proportion != 0){
            proportion = proportion*.9+.1
        }

        // Flip proportion
        proportion = 1-(proportion);

        var hex = (Math.round(proportion*255)).toString(16);
        if (hex.length == 1) {
            hex = "0"+hex;
        }
        return "#FF"+hex+hex;
    },

    // takes an array of numbers and draws a heat map
    draw_array : function (_x,_y,s,arry) {
        var max_num = 0;
        arry.map(function(row){
            row.map(function(elem){
                if (elem > max_num) {
                    max_num = elem;
                }
            })
        });
        if (max_num == 0) {
            max_num = 1;
        }

        for (var y = 0; y < arry.length; y++) {
            var row = arry[y];
            for (var x = 0; x < row.length; x++) {
                var elem = row[x];
                this.draw_rect(
                    _x+x*s, 
                    _y+y*s, 
                    s, 
                    s, 
                    this.get_heat(elem, max_num)
                );
            }
        }
    }
}