import load_data
import sys

class CountingDictionary:
    def __init__(self):
        self.dict = {}

    def increment(self, item):
        if not item in self.dict:
            self.dict[item] = 1
        else:
            self.dict[item] += 1

    def get_count(self, item):
        if not item in self.dict:
            return 0
        else:
            return self.dict[item]

    def get_dict(self):
        return self.dict

class AppendingDictionary:
    def __init__(self):
        self.dict = {}

    def add(self, key, value):
        if not key in self.dict:
            self.dict[key] = [value]
        else:
            self.dict[key].append(value)

    def get_list(self, key):
        if not key in self.dict:
            return []
        else:
            return self.dict[key]

    def get_dict(self):
        return self.dict

def main(args):
    json_data = load_data.readJsonFromFile(args[1])

def convertLevelDataDictToPercentages(level_dict):
    level_percentages = {}

def getLevelDataDict(user_quest_dict):
    beaten = CountingDictionary()
    got_past = CountingDictionary()
    num_plays = CountingDictionary()
    all_players = AppendingDictionary()

    for user in user_quest_dict:
        quest_array = user_quest_dict[user]

        for lvl_num in quest_array:
            num_plays.increment(lvl_num)
            all_players.add(lvl_num, user)

        quest_array = list(set(quest_array))
        quest_array.sort()

        highest_level_reached = quest_array[-1]
        for i in range(1, highest_level_reached + 1):
            got_past.increment(i)

        for lvl_num in quest_array:
            beaten.increment(lvl_num)

    deaths_per_level = {}
    for lvl_num in num_plays.get_dict():
        plays = num_plays.get_count(lvl_num) - 1
        players = len(set(all_players.get_list(lvl_num)))
        deaths_per_level[lvl_num] = float(plays) / players

    return beaten.get_dict(), got_past.get_dict(), deaths_per_level

def getDictOfUserIdToQuestArray(json_data):
    quests = json_data["player_quests"]
    user_quest_dict = {}
    for quest in quests:
        user = quest["user_id"]
        if not user in user_quest_dict:
            user_quest_dict[user] = []
        user_quest_dict[user].append(int(quest["quest_id"]))
    return user_quest_dict

if __name__ == '__main__':
    main(sys.argv)
