import requests
import json

# from requests.sessions import _TextMapping

ATHLETES = []

active_list = [
    'T.Brady',
    'P.Mahomes',
    'J.Allen',
    'L.Jackson',
    'D.Adams',
    'S.Diggs',
    'C.Ridley',
    'D.Metcalf',
    'T.Hill',
    'D.Henry',
    'D.Cook',
    'D.Harris',
    'N.Harris'
]

host = 'http://54.38.139.134:9000'

class Athlete():
    def __init__(self, name):
        self.name = name
        self.team = None
        self.position = None
        self.passingYards = []
        self.passingTouchdowns = []
        self.reception = []
        self.receiveYards = []
        self.receiveTouch = []
        self.rushingYards = []
        self.price = []
        self.time = []

    def make_dict(self):
        id = self.name[-5:].replace('_', '')
        return (id, {"name": self.name[:-5].replace('_', ''), "history":self.history})

for athlete in active_list: 
    new_athlete = Athlete(athlete)
    ATHLETES.append(new_athlete)

for athlete in ATHLETES:
    print(athlete.name)

# for athlete in active_list[:1]:        
#     try:
#         sql_query = f"select * from nfl where name = '{athlete}'" # loop through current athletes and select only the data one by one
#         response = requests.post(host + '/exec', params={'query': sql_query})
#         json_response = json.loads(response.text)
#         rows = json_response['dataset']
#         print(rows)
#     except requests.exceptions.RequestException as e:
#         print("Error: %s" % (e))


# jsondata = []
# for athlete in ATHLETES:
#     id, json_data = athlete.make_dict()
#     jsondata.append(json_data)

# with open('../../assets/data.json', 'w') as f:
#     json.dump(jsondata, f)
    