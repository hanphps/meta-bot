import serial
from parser import parse

class robot:

    """
        TODO:
        - Integrate WiFI/ZigBee/ESP8266
    """
    def __init__(self,settings):
        self.settings = parse(settings)
        print(self.settings)
        self.coms = serial.Serial(self.settings["com"],self.settings["baud"])
        self.coms.timeout = self.settings["timeout"]
        self.READY = False

    def start(self):
        '''
            TODO:
            - Depricate this. This basically gives robot one push to start it to going
        '''
        while self.READY != True:
            inp = (self.coms.readline())[:-2].decode("utf-8")
            self.coms.flush()
            if inp == 'READY':
                print('Ready')
                self.READY = True
            else:
                print(inp)
                print('Not ready')
                self.coms.write('N'.encode())

    def ready_up(self):
        while self.READY != True:
            inp = (self.coms.readline())[:-2].decode("utf-8")
            #self.coms.flush()
            if inp == 'READY':
                print('Ready')
                self.READY = True
            else:
                print(inp)

    def send_command(self,command):
        if self.READY:
            self.coms.write(command.encode())
            self.READY = False
            self.ready_up()
