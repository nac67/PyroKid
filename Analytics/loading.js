



function processFireball (json, shared) {
    var fball_info = ParsingUtils.parse_fireball(json);
}




function processDeath (json, shared) {
    var parsed_death = ParsingUtils.parse_death(json);
    if (typeof (shared.levels[parsed_death.level]) === 'undefined'){
        shared.levels[parsed_death.level] = [];
    }
     
    shared.levels[parsed_death.level].push([parsed_death.x, parsed_death.y]);

    shared.count++;
}

function load() {




    // ------------------
    // random stats
    // ------------------
    var mydata = JSON.parse(data);


    //////// fucking drop off poop fuck shit

    var quests = mydata["player_quests"];
    var user_quests = {};
    for (var i = 0; i < quests.length; i++) {
        var user = quests[i]["user_id"];
        var quest_array = user_quests[user];
        if (typeof(quest_array) === "undefined") {
            user_quests[user] = [];
        }
        user_quests[user].push(parseInt(quests[i]["quest_id"]));
    }
    for (var user_id in user_quests) {
        if (user_quests.hasOwnProperty(user_id)) {
            var quest_array = user_quests[user_id];
            quest_array = quest_array.sort(function(a,b) { return a - b; });
            quest_array = quest_array.filter(function(item, pos, self) {
                return self.indexOf(item) == pos;
            });

            var i = 0;
            var first_level_completed = quest_array[0];
            var highest_consecutive_except_tutorials = 0;
            for (var j = 0; j < quest_array.length; j++) {
                if (j > 0 && quest_array[j] > 7 && quest_array[j] != quest_array[j-1] + 1) {
                    break;
                }
                highest_consecutive_except_tutorials = quest_array[j];
            }
            if (quest_array.length == 1 && highest_consecutive_except_tutorials > 7) {
                highest_consecutive_except_tutorials = 0;
            }
            for (; i < quest_array.length; i++) {
                if (quest_array[i] != i + 1) {
                    break;
                }
            }
            var highest_consecutive = i;
            var highest_absolute = quest_array[quest_array.length - 1];
            console.log(user_id + ", " + highest_consecutive + ", " + highest_consecutive_except_tutorials + ", " + highest_absolute);
        }
    }


    //////// end blurgh pusadflkjalse


    //console.log("Number of page loads: " + mydata["page_loads"].length);

    var big_ass_hashmap = {}
    mydata["page_loads"].map(function(elem){
        big_ass_hashmap[elem["user_id"]] = true;
    });
    //console.log("Number of unique page loads: " + ParsingUtils.countProperties(big_ass_hashmap));

    //console.log("Number of actions: " + mydata["player_actions"].length);
    //console.log("Number of quests: " + mydata["player_quests"].length);

    var fball_info = {count:0};
    var death_info = {count:0, levels : []};


    // ------------------
    // process actions
    // ------------------
    mydata["player_actions"].map(function(elem){
        if (elem["action_id"] == 1) {
            processDeath(elem, death_info);
        } else if (elem["action_id"] == 2) {
            processFireball(elem, fball_info);
        }
    });

    var death_map = death_info.levels.map(function(level) {
        return ParsingUtils.list_of_points_to_array(level)
    });

    DrawingTools.draw_array(0,0,50,death_map[27]);
    
}