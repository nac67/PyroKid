import urllib2
import requests
import sys
import os
import json

# returns True iff it is done writing all data
def appendToFile(file_name, json_data):
    if not os.path.isfile(file_name):
        data_file = open(file_name, "w")
        data_file.close()
        data_dict = {}
    else:
        data_file = open(file_name, "r")
        data = data_file.read()
        data_dict = json.loads(data)
        data_file.close()

    print "len of dict: " + str(len(data_dict))
    empty = True
    for k in json_data:
        print "key: " + k
        new_data = json_data[k]
        empty = empty and len(new_data) == 0
        if k in data_dict:
            data_dict[k] = data_dict[k] + new_data
        else:
            data_dict[k] = new_data
        print "len of key after combining: " + str(len(data_dict[k]))
    print "len of dict after combining: " + str(len(data_dict))

    data_file = open(file_name, "a")
    data_file.write(json.dumps(data_dict))
    data_file.close()
    return empty

def writeJsonToFile(file_name, json_data):
    data_file = open(file_name, "w")
    data_file.write(json.dumps(json_data))
    data_file.close()

def readJsonFromFile(file_name):
    data_file = open(file_name, "r")
    data = data_file.read()
    data_file.close()
    return json.loads(data)

def getJsonAsDict(page):
    offset = page * 50000
    url = "http://gdiac.cs.cornell.edu/cs4154/fall2014/get_data.php?game_id=100&version_id=3&offset=" + str(offset)
    r = requests.get(url)
    html = r.text
    data_string = html.split("<hr/>")[1]
    my_dict = json.loads(data_string)
    return my_dict

def dictEmpty(my_dict):
    for k in my_dict:
        if len(my_dict[k]) != 0:
            return False
    return True

# adds all data in dict2 into dict1
def mergeDict(dict1, dict2):
    for k in dict2:
        #print "key: " + k
        new_data = dict2[k]
        if k in dict1:
            dict1[k] = dict1[k] + new_data
        else:
            dict1[k] = new_data
        #print "len of key after combining: " + str(len(data_dict[k]))
    #print "len of dict after combining: " + str(len(data_dict))

def main(args):
    i = 0
    all_json_data = {}
    json_data = getJsonAsDict(i)
    while not dictEmpty(json_data):
        print "page " + str(i)
        print "len data: " + str(len(json_data))
        for k in json_data:
            print k + ": " + str(len(json_data[k]))
        print "\n"

        mergeDict(all_json_data, json_data)
        writeJsonToFile("version3data_temp" + str(i), all_json_data)

        i += 1
        json_data = getJsonAsDict(i)
        #balls = appendToFile("butts", json)
        #print "empty: " + str(balls)

    writeJsonToFile("version3data", all_json_data)
    #all_json_data2 = readJsonFromFile("version3data")

    #print "done writing file"
    #for k in all_json_data:
    #    print "all json 1: " + k + ": " + str(len(all_json_data[k]))
    #    print "all json 2: " + k + ": " + str(len(all_json_data2[k]))

if __name__ == '__main__':
    main(sys.argv)
