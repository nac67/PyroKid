var ParsingUtils = {

    //counts the number of items in an object
    countProperties : function(obj) {
        var count = 0;

        for(var prop in obj) {
            if(obj.hasOwnProperty(prop))
                ++count;
        }

        return count;
    },

    // returns {x, y, reason, time_of_death}
    parse_death : function (json) {
        var string = json["action detail"];
        var pieces = string.split(",");
        return {
            x : pieces[0].split(":")[1],
            y : pieces[1],
            reason : pieces[2],
            time_of_death : pieces[3],
            level : json["quest_id"]
        }
    },

    // returns {x, y, hit_object}
    parse_fireball : function (json) {
        //"action detail":"fball: 5,7,[class BurnQuickly]"
        var string = json["action detail"];
        var pieces = string.split(",");
        return {
            x : pieces[0].split(":")[1],
            y : pieces[1],
            hit_object : pieces[2]
        }
    },

    //converts points represented in a dictionary to a 2d array with same numbers
    dict_to_array : function (dict) {
        var max_x = 0;
        var max_y = 0;
        for (var point in dict) {
            if (dict.hasOwnProperty(point)) {
                var point_arr = point.split(",")
                
                //for some reason map isn't working :(
                point_arr2 = [parseInt(point_arr[0]), parseInt(point_arr[1])]
                if (point_arr[0] > max_x) max_x = point_arr[0]
                if (point_arr[1] > max_y) max_y = point_arr[1]
            }
        }

        var result = []
        for (var i=0;i<=max_y;i++){
            result.push([])
            for(var j=0;j<=max_x;j++){
                result[i].push(0);
            }
        }


        for (var point in dict) {
            if (dict.hasOwnProperty(point)) {
                var point_arr = point.split(",")
                
                //for some reason map isn't working :(
                point_arr2 = [parseInt(point_arr[0]), parseInt(point_arr[1])]


                console.log(point_arr2)
                result[point_arr2[1]][point_arr2[0]] =dict[point];
            }
        }

        return result;
    },

    //converts list of points where each point INCREMENTS a count in a 2d array
    list_of_points_to_array : function (lst) {
        var max_x = 0;
        var max_y = 0;

        for (var i=0;i<lst.length;i++) {
            if(lst[i][0] > max_x) max_x = Number(lst[i][0])
            if(lst[i][1] > max_y) max_y = Number(lst[i][1])
        }

        var result = []
        for (var i=0;i<=max_y+1;i++){
            result.push([])
            for(var j=0;j<=max_x+1;j++){
                result[i].push(0);
            }
        }

        for (var i=0;i<lst.length;i++) {
            var point = lst[i].map(Number);
            result[point[1]][point[0]]++;
        }

        return result
    }
}