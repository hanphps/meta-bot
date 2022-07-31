import pyrebase
from parser import parse

class firebase:

    """
        TODO:
        - Fix issue with double requesting (I think this is fixed?)
        - Check for value case on Requests (i.e. is thee Request a legitimate request?)
        
    """

    def __init__(self,settings,cred):
        # cred is a parsed .json file with credentials
        cred = parse(cred)
        self.app = pyrebase.initialize_app(cred)
        self.settings = parse(settings)

    #functions properly
    def clear_entry(self,store,data):
        db = self.app.database()
        key = 0
        for entry in db.child(store).get().each():
            print(entry.val())
            print(data)
            if entry.val()['Time'] == data:
                print('Entry found')
                key = entry.key()
        if key == 0:
            return 0
        if self.settings['delete_data'] == True:
            db.child(store).child(key).remove()
        else:
            print('Data deletion is not enabled')

    #functions properly
    def add_to_queue(self,data):
        db = self.app.database()
        entry = db.child('Queue').get()
        if entry == None:
            db.child('Queue').remove()
            return None
        elif entry.val() == None:
            db.child('Queue').set(data)
            return None
        elif entry.val()['Complete'] == True:
            db.child('Queue').set(data)
            return True
        else:
            return False

    #function properly
    def add_to_history(self,data):
        """
            TODO:
            - Add when completed metric to History entries
        """
        db = self.app.database()
        history = db.child('History')
        if self.settings['add_data']:
            history.push(data)
        else:
            print('Pushing data is not enabled')

    #functions properly        
    def get_direction(self):
        db = self.app.database()
        entry = db.child('Queue').get()

        if entry.val() != None:
            if entry.val()["Direction"] != None:
                return entry.val()["Direction"]
    
    def set_complete(self,val):
        db = self.app.database()
        entry = db.child('Queue').get()

        if entry.val() != None:
            if entry.val()['Complete'] != None:
                db.child('Queue').child('Complete').set(val)

    #functions properly
    def push_to_queue(self):
        db = self.app.database()
        queue = db.child('Queue').get()
        requests = db.child('Requests').get().each()
        if requests != None:
            if len(requests)>0:
                request = requests[0]
                try:
                    self.clear_entry('Requests',request.val()["Time"])
                except:
                    print('Request probably already deleted')

                push = self.add_to_queue(request.val())
                if push:
                    print('Push to robot successful')
                    self.add_to_history(queue.val())
                elif push == None:
                    print('No Queue')
        else:
            try:
                self.clear_entry('Requests',queue.val()["Time"])
            except:
                print('Request probably did not exist')
            push = self.add_to_queue(requests)
            
            if push == None or push == True: 
                self.add_to_history(queue.val())
                print('No more entries')
        
    def get_entries(self,store):
        db = self.app.database()
        got = db.child(store).get()
        for entry in got.each():
            print(entry.val())