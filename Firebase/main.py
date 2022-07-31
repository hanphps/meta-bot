from firebase import firebase
from robot import robot
from time import sleep

'''
    TODO:
    - Twitch Integration
'''

ROB = robot('Bot/robot.json')
FIREBASE = firebase('Firebase/settings.json','Firebase/config.json')

ROB.start()

def run():
    while True:
        if ROB.READY:
            FIREBASE.push_to_queue()
            dir = FIREBASE.get_direction()
            if dir != None:
                ROB.send_command(dir)
            """
                TODO:
                    -Make sure Robot verifies it completes task than assumes it has completed its task
            """
            sleep(3)
            FIREBASE.set_complete(True)

run()
