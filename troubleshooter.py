#!/usr/bin/env python

import os
import subprocess
import re
import datetime

def lastreboot():
    #This function would open and query the /log/syslog.log file for reboot evidences.    
    #Regex to find the word "Busybox" 
    line_regex = re.compile(r"\b(syslogd started: BusyBox)\b")
    with open("/log/syslog.log", "r") as in_file:
        # Loop over each log line
        loopstart = datetime.datetime.now()
        vlinetotal = 0
        for line in in_file:
            # If log line matches our regex, print to console, and output file
            vlinetotal = vlinetotal + 1
            if (line_regex.search(line)):
                print (line.rstrip("\n"))
        loopend = datetime.datetime.now()
        print ('Took {} seconds to run'.format(loopend - loopstart))
        print ("total number of lines read : {}".format(vlinetotal))
    pass

def showsysteminfo():
    #
    with open("/etc/cccversion", "r") as version_file:
        for line in version_file:
            s = line.rstrip("\n")
            print ("Version : {}".format(s))



def cligrep():
    somecommand = subprocess.Popen('grep',
                                   
        
    )
    


def menu ():
    print ('   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    print ('                             XG Troubleshooter')
    print ('                            author:Luiz Camilo')
    print ('https://raw.githubusercontent.com/lacamilo/xgtroubleshooter/main/troubleshooter.py')
    print ('   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    print ('1. Show System info                           | 10. Show disk I/O')
    print ('2. Last reboot from syslog.log                | 11. List listening Sockets')
    print ('3. Show IPSEC status details                  | 12. ')
    print ('4. Show IPSEC retransmissions                 |')
    print ('5. Show Dead Gateway detection link failures  |')
    print ('6. Get Admin port from SQL database           |')
    print ('7. Reveal IPSEC PSK for all vpns              |')
    print ('8. List backend scheduled tasks               |')
    print ('9. Run WAN Speedtest                          |')
    print ('0. Exit')

def read_options(): 
    while True:
        #os.system('clear') # attempt to clear the screen keeping the menu always on top
        option = input()
        if option == '1':
            #print ('option 1 selected')
            showsysteminfo()
            print ('Done, press Enter to continue')
            key = input()
            menu()
            exit
        elif option == '2':
            #print ('option 2 selected')
            lastreboot()
            print ('Done, press Enter to continue')
            key = input()
            menu()
            exit
        elif option == '3':
            print ('option 3 selected')
        elif option == '4':
            print ('option 4 selected')
        elif option == '5':
            print ('option 5 selected')
        elif option == '6':
            print ('option 6 selected')
        elif option == '7':
            print ('option 7 selected')
        elif option == '8':
            print ('option 8 selected')
        elif option == '9':
            print ('option 9 selected')
        elif option == '10':
            print ('option 10 selected')
        elif option == '11':
            print ('option 11 selected')
        elif option == '12':
            print ('option 12 selected')
        elif option == ('0' or 'q'): 
            print ('Quitting...')
            break
    
def main (): 
    menu ()
    read_options()

if __name__ == '__main__': main()
