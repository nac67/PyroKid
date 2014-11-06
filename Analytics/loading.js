



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

    console.log("Number of page loads: " + mydata["page_loads"].length);

    var big_ass_hashmap = {}
    mydata["page_loads"].map(function(elem){
        big_ass_hashmap[elem["user_id"]] = true;
    });
    console.log("Number of unique page loads: " + ParsingUtils.countProperties(big_ass_hashmap));

    console.log("Number of actions: " + mydata["player_actions"].length);
    console.log("Number of quests: " + mydata["player_quests"].length);

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