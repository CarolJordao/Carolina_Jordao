#import package for colored text
import colorama
from colorama import Fore
# import package to build delays on text
import time


######### BEGINNING OF THE GAME #########

# INTRODUCTION STARTS WITH A COLORED WELCOME MESSAGE
print(Fore.MAGENTA + """
                                 _    _ _____ _     _____ ________  ___ _____ 
                                | |  | |  ___| |   /  __ \  _  |  \/  ||  ___|
                                | |  | | |__ | |   | /  \/ | | | .  . || |__  
                                | |/\| |  __|| |   | |   | | | | |\/| ||  __| 
                                \  /\  / |___| |___| \__/\ \_/ / |  | || |___ 
                                 \/  \/\____/\_____/\____/\___/\_|  |_/\____/ 

                              _____ _____   _____ ___  ______ ______  ___   _   _ 
                            |_   _|  _  | |_   _/ _ \ | ___ \___  / / _ \ | \ | |
                              | | | | | |   | |/ /_\ \| |_/ /  / / / /_\ \|  \| |
                              | | | | | |   | ||  _  ||    /  / /  |  _  || . ` |
                              | | \ \_/ /   | || | | || |\ \./ /___| | | || |\  |
                              \_/  \___/    \_/\_| |_/\_| \_\_____/\_| |_/\_| \_/



""" + Fore.RESET)  # fore.magenta is used to call the color magenta to the text
                   # fore.reset is used to reset to the original color                                            

# ALLOWING USERS TO INPUT THEIR NAMES
name = input("""What is your name?:""")
print(f"""Hi {name} 👋🏻! Nice to meet you! Hope you are as excited as me!""") #f-string to replace with the name variable
time.sleep(1) #to cause a delay of 1 second

# ASKING THE PLAYER IF THEY WATCHED THE MOVIE BEFORE WITH A YES OR NO QUESTION
while True: # while loop in case the player types something unrecognisable
    answer = input("""Have you watched the movie "Tarzan"?""")

    # conditional clause yes vs no  
    if answer in ("yes", "Yes", "YES", "y", "Y"): 
        print(Fore.GREEN + """That's great! You're gonna have a good time. Let's begin!""" +  Fore.RESET)
        time.sleep(1)
        break
        
    elif answer in ("no", "No", "NO", "n", "N"):
        print(Fore.RED + """Oh, that's okay 😕 """+  Fore.RESET)
        input("""What's your favorite movie?""")
        time.sleep(0.5)
        print("""That's a great one! I'll take your suggestion one of these days 🥰""")
        time.sleep(1)
        break
        
    else:
        print("I didn't get that.")
    
# SHOWCASING THE STORY BEHIND THE GAME  
print(Fore.MAGENTA + """
                
******************************************

Here's a little context:

Tarzan was found in the jungle by an ape called Kala. Kala and the ape civilization
decided to take care of baby Tarzan. While he grew up, he learned many skills from 
the animals in the jungle. One day, he meets Jane and falls in love with her 💗💕💓💖💘


But.........


All of a sudden, something happens and Tarzan needs your help!

******************************************
""" + Fore.RESET)
time.sleep(2)
    
    
print(Fore.YELLOW + """
ARE YOU READY TO KNOW WHAT HAPPENED? 
Press <ENTER> to find out 😳

""" + Fore.RESET)
input() #input statement is separated from the colored string because otherwise it doesn't show the color



# DEFINING ROOM 1
def room1():
    
    print(Fore.BLUE + """
*********************************************************

                WELCOME TO 

██╗     ███████╗██╗   ██╗███████╗██╗          ██╗
██║     ██╔════╝██║   ██║██╔════╝██║         ███║
██║     █████╗  ██║   ██║█████╗  ██║         ╚██║
██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║          ██║
███████╗███████╗ ╚████╔╝ ███████╗███████╗     ██║
╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝     ╚═╝

*********************************************************
""" + Fore.RESET)


    
    
    print(Fore.RED + """
Today, Tarzan woke up and he found out that Jane 
had been kidnapped and hidden somewhere by the babboons 🐒. 
⚠️ He needs your help on this mission ⚠️ 
""" + Fore.RESET)
    time.sleep(1)
    input(""" Press <ENTER> to continue""")

# SHOWING THE PLAYER THE WEAPON OPTIONS
    print("""
First, you need to choose your weapon. 
These are your options:\n""")
    
    #creating a list 
    weapon_lst = [' 🪵 stick', ' 🔫 shotgun', ' 🔪 knife']
    for weapon in weapon_lst: # for loop to print the list of weapons

        print(f"""{weapon}""") #f-string to make it automatic, instead of writting all 3 weapons.
        time.sleep(1)

    ## ASKING THE PLAYER TO CHOOSE A WEAPON
    while True: # while loop to retry if the player types the wrong answer
        weapon = input("""Which one do you want?""")

        if weapon in ("stick", "shotgun", "knife"):
            print(f"""
Good!! You chose a {weapon} and now you need to rush to follow 
the baboons and save Jane!""")
            break # to stop the loop if the player writes the weapon's name correctly

        else:
            print("""Please try again\t""") # in case the player types an unknown word or typo


# RUNNING EMOJIS TO CREATE DYNAMIC AND INTERACTIVITY TO THE GAME            
    
    print(Fore.RED + """     
  _   _   _   _   _   _  
 / \ / \ / \ / \ / \ / \ 
( R | U | N | ! | ! | ! )
 \_/ \_/ \_/ \_/ \_/ \_/ 
""" + Fore.RESET) 
    time.sleep(1)
    print("""
         🏃🏻‍♂️""")
    time.sleep(0.5)
    print("""
         🏃🏻‍♂️""")
    time.sleep(0.5)
    print("""
         🏃🏻‍♂️""")
    time.sleep(0.5)
    print("""
         🏃🏻‍♂️""")
    time.sleep(0.5)
    print("""
         🏃🏻‍♂️""")
    time.sleep(0.5)
    print("""
         🏃🏻‍♂️""")
    time.sleep(0.5)
    
# FIRST QUEST
    while True: # while loop to make the player start over in case they fail or type something wrong   
        print(Fore.BLUE + """
OH NOOO!! You lost the baboons and you arrive to a crossroads ↖️↗️. 
You can choose to go left or right. \t"""
         + Fore.RESET)

        crossroads = input("""Type "left" or "right:""") #input clause needs to be separated from the colored print clause

        if crossroads == "left": 
            print("""
Damn!! The baboons placed a trap on the floor and you fell into it...You're dead 😢

But okay, I'll give you another chance ❤️. Start from the beginning""")
            time.sleep(1)
            

        elif crossroads == "right":
            while True: # while loop to  make the player start over in case they fail or type something wrong
                # SUB QUEST
                print("""
Good choice! The baboons had placed a trap on the left. You escaped it! 
And now you arrive to a river. What do you want to do next?:
                  1. Swim through the river 🌊
                  2. Walk around it 🔄\n""") 
                next_ = print(Fore.BLUE + """What's your choice, 1 or 2?""" + Fore.RESET)
                next_ = input()

                if next_ == "1":
                    print("""Oopsi...There was an alligator 🐊 waiting for you. You died 😢""")
                    print("""But I want you to keep playing my game so here's another life ❤️. Start from the beginning""")
                    time.sleep(1)
                    
            
                elif next_ == "2": 
                    print("""
You walked many miles and ran out of water but you survived!  
You fell into a portal and became unconscious 😵 """)
                    room2() # this moves the player to level 2
                    break # to stop the loop when player types 2
                    
                else: 
                    print("""I didn't get that. Please try again?\t""") # in case player makes a typo
                    
            break # break the first while loop when player types "right"
            
        else: 
            print("""I didn't get that. Please try again?\t""") # in case player makes a typo

# DEFINING ROOM 2
def room2():
    
    time.sleep(2) # delay of 2 seconds to enter the room.
    print(Fore.MAGENTA + """  
    
    
    
                CONGRATULATIONS! 
                You made it to

██╗     ███████╗██╗   ██╗███████╗██╗         ██████╗ 
██║     ██╔════╝██║   ██║██╔════╝██║         ╚════██╗
██║     █████╗  ██║   ██║█████╗  ██║          █████╔╝
██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║         ██╔═══╝ 
███████╗███████╗ ╚████╔╝ ███████╗███████╗    ███████╗
╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝    ╚══════╝

""" + Fore.RESET)
    time.sleep(2)
    
    
# ASKING THE PLAYER TO CHOOSE A SUPERPOWER    
    print(Fore.BLUE + """

You won the possibility to choose a SUPERPOWER 🪄. Type 1 or 2:
1. Being super strong 💪🏻
2. Being invisible 😶‍🌫️ \n
""" + Fore.RESET)

    while True: # while loop in case the player types something else than 1 or 2
        try: # try except clause to handle errors
            superpower = int(input("""Choose a number:"""))
            if superpower == 1:
                print("""WOW! Now you are super strong so you broke into the bunker's wall and escaped! """)
                break #to stop the loop once the player types 1             

            else:
                print("""WOW! Now you are invisible so you walked throught the wall and escaped! """)
                break #to stop the loop once the player types 2       

        except:
            print("""There was no valid number. Try again:""") 

# SECOND QUEST
    print(Fore.YELLOW + """Let's continue looking for Jane. You should climb a tree 🌴 to see if you spot her 👀. """ + Fore.RESET)

    print(".")
    time.sleep(0.5)
    print(".")
    time.sleep(0.5)
    print(".")
    time.sleep(0.5)
    print(".")
    time.sleep(0.5)
    print(".")
    time.sleep(0.5)
    print(".")
    time.sleep(0.5)

    print("""
  _ _ _  __     ______  _    _      _____ ______ ______     _    _ ______ _____    _ _ _ 
 | | | | \ \   / / __ \| |  | |    / ____|  ____|  ____|   | |  | |  ____|  __ \  | | | |
 | | | |  \ \_/ / |  | | |  | |   | (___ | |__  | |__      | |__| | |__  | |__) | | | | |
 | | | |   \   /| |  | | |  | |    \___ \|  __| |  __|     |  __  |  __| |  _  /  | | | |
 |_|_|_|    | | | |__| | |__| |    ____) | |____| |____    | |  | | |____| | \ \  |_|_|_|
 (_|_|_)    |_|  \____/ \____/    |_____/|______|______|   |_|  |_|______|_|  \_\ (_|_|_)
                                                                                         
 Jane is hiding on a tree.""")

    
#THIRD QUEST
    print(Fore.BLUE + """

Choose how you want to go meet her. Type 1 or 2:
1. Swing on the vines 
2. Jump from tree to tree\n""" + Fore.RESET)
    
    while True: # while loop in case the player types something else than 1 or 2
        tree = input("""Answer:""")
        if tree == "1":
            print("""Good job! You found Jane!!
            """)
            room3() # this moves the player to room 3
            break #to stop the loop once the player types 2       
            
        elif tree == "2":
            print("""Good job! You found Jane!!""")
            room3() # this moves the player to room 3
            break #to stop the loop once the player types 2       
            
        else:
            print("""I don't know what you said. Try again please!""")

# DEFINING ROOM 3

def room3():
    
    time.sleep(1) # to delay the appearance of level 3
    print(Fore.CYAN + """
    
            WOW!! You're a warrior!!!
                  WELCOME TO

██╗     ███████╗██╗   ██╗███████╗██╗         ██████╗ 
██║     ██╔════╝██║   ██║██╔════╝██║         ╚════██╗
██║     █████╗  ██║   ██║█████╗  ██║          █████╔╝
██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║          ╚═══██╗
███████╗███████╗ ╚████╔╝ ███████╗███████╗    ██████╔╝
╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝    ╚═════╝ 

                            """ + Fore.RESET)
    time.sleep(1)
    
    
    
    
#FINAL QUEST
    print(Fore.YELLOW + f"""
You are with Jane, but one of the baboons wants to fight you!

    Press 1 to punch the baboon 👊🏻
    Press 2 to kick the baboon🦵🏻
    Press 3 to throw Jane at the baboon and run away 💨 
    
""" + Fore.RESET)
    
    while True:# while loop in case the player types something else than 1 or 2
        answer = input("What's your choice?")
        if answer == "1":
            print("""BAM 👊🏻!!! You killed the baboon!""")
            win() # this calls the win function
            break #to stop the loop once the player types 2       

        elif answer == "2":
            print("""AUTCH!!! That was a hard kick, good job! You killed the baboon""")
            win() # this calls the win function
            break #to stop the loop once the player types 2       

        elif answer == "3":
            print("""WOW! You really don't care about Jane...You're kicked out of my game 😡""")
            fail() # this calls the fail function
            break #to stop the loop once the player types 2       

        else:
            print("""That doesn't seem correct...Try again:""")

            
            
            
# DEFINING A WIN FUNCTION            
def win():
    
    print(Fore.GREEN + """

 ██████╗ ██████╗ ███╗   ██╗ ██████╗ ██████╗  █████╗ ████████╗███████╗██╗██╗    
██╔════╝██╔═══██╗████╗  ██║██╔════╝ ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║██║    
██║     ██║   ██║██╔██╗ ██║██║  ███╗██████╔╝███████║   ██║   ███████╗██║██║    
██║     ██║   ██║██║╚██╗██║██║   ██║██╔══██╗██╔══██║   ██║   ╚════██║╚═╝╚═╝    
╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝██║  ██║██║  ██║   ██║   ███████║██╗██╗    
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝╚═╝    




      ██╗   ██╗ ██████╗ ██╗   ██╗    ██╗    ██╗ ██████╗ ███╗   ██╗                   
      ╚██╗ ██╔╝██╔═══██╗██║   ██║    ██║    ██║██╔═══██╗████╗  ██║                   
       ╚████╔╝ ██║   ██║██║   ██║    ██║ █╗ ██║██║   ██║██╔██╗ ██║                   
        ╚██╔╝  ██║   ██║██║   ██║    ██║███╗██║██║   ██║██║╚██╗██║                   
         ██║   ╚██████╔╝╚██████╔╝    ╚███╔███╔╝╚██████╔╝██║ ╚████║                   
         ╚═╝    ╚═════╝  ╚═════╝      ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═══╝                   


                                                                                

    
    """ + Fore.RESET)
    
    
    
    
# DEFINING A FAIL FUNCTION
def fail():
    print(Fore.RED + """

    SORRY...BEST LUCK NEXT TIME 


    LLLLLLLLLLL                  OOOOOOOOO        SSSSSSSSSSSSSSS EEEEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRRRR   
    L:::::::::L                OO:::::::::OO    SS:::::::::::::::SE::::::::::::::::::::ER::::::::::::::::R  
    L:::::::::L              OO:::::::::::::OO S:::::SSSSSS::::::SE::::::::::::::::::::ER::::::RRRRRR:::::R 
    LL:::::::LL             O:::::::OOO:::::::OS:::::S     SSSSSSSEE::::::EEEEEEEEE::::ERR:::::R     R:::::R
      L:::::L               O::::::O   O::::::OS:::::S              E:::::E       EEEEEE  R::::R     R:::::R
      L:::::L               O:::::O     O:::::OS:::::S              E:::::E               R::::R     R:::::R
      L:::::L               O:::::O     O:::::O S::::SSSS           E::::::EEEEEEEEEE     R::::RRRRRR:::::R 
      L:::::L               O:::::O     O:::::O  SS::::::SSSSS      E:::::::::::::::E     R:::::::::::::RR  
      L:::::L               O:::::O     O:::::O    SSS::::::::SS    E:::::::::::::::E     R::::RRRRRR:::::R 
      L:::::L               O:::::O     O:::::O       SSSSSS::::S   E::::::EEEEEEEEEE     R::::R     R:::::R
      L:::::L               O:::::O     O:::::O            S:::::S  E:::::E               R::::R     R:::::R
      L:::::L         LLLLLLO::::::O   O::::::O            S:::::S  E:::::E       EEEEEE  R::::R     R:::::R
    LL:::::::LLLLLLLLL:::::LO:::::::OOO:::::::OSSSSSSS     S:::::SEE::::::EEEEEEEE:::::ERR:::::R     R:::::R
    L::::::::::::::::::::::L OO:::::::::::::OO S::::::SSSSSS:::::SE::::::::::::::::::::ER::::::R     R:::::R
    L::::::::::::::::::::::L   OO:::::::::OO   S:::::::::::::::SS E::::::::::::::::::::ER::::::R     R:::::R
    LLLLLLLLLLLLLLLLLLLLLLLL     OOOOOOOOO      SSSSSSSSSSSSSSS   EEEEEEEEEEEEEEEEEEEEEERRRRRRRR     RRRRRRR


                                                _,.-------.,_
                                            ,;~'             '~;,
                                          ,;                     ;,
                                         ;                         ;
                                        ,'                         ',
                                       ,;                           ;,
                                       ; ;      .           .      ; ;
                                       | ;   ______       ______   ; |
                                       |  `/~"     ~" . "~     "~\'  |
                                       |  ~  ,-~~~^~, | ,~^~~~-,  ~  |
                                        |   |        }:{        |   |
                                        |   l       / | \       !   |
                                        .~  (__,.--" .^. "--.,__)  ~.
                                        |     ---;' / | \ `;---     |
                                         \__.       \/^\/       .__/
                                          V| \                 / |V
                       __                  | |T~\___!___!___/~T| |                  _____
                    .-~  ~"-.              | |`IIII_I_I_I_IIII'| |               .-~     "-.
                   /         \             |  \,III I I I III,/  |              /           Y
                  Y          ;              \   `~~~~~~~~~~'    /               i           |
                  `.   _     `._              \   .       .   /               __)         .'
                    )=~         `-.._           \.    ^    ./           _..-'~         ~"<_
                 .-~                 ~`-.._       ^~~~^~~~^       _..-'~                   ~.
                /                          ~`-.._           _..-'~                           Y
                {        .~"-._                  ~`-.._ .-'~                  _..-~;         ;
                 `._   _,'     ~`-.._                  ~`-.._           _..-'~     `._    _.-
                    ~~"              ~`-.._                  ~`-.._ .-'~              ~~"~
                  .----.            _..-'  ~`-.._                  ~`-.._          .-~~~~-.
                 /      `.    _..-'~             ~`-.._                  ~`-.._   (        ".
                Y        `=--~                  _..-'  ~`-.._                  ~`-'         |
                |                         _..-'~             ~`-.._                         ;
                `._                 _..-'~                         ~`-.._            -._ _.'
                   "-.="      _..-'~                                     ~`-.._        ~`.
                    /        `.                                                ;          Y
                   Y           Y                                              Y           |
                   |           ;                                              `.          /
                   `.       _.'                                                 "-.____.-'
                     ~-----"

    """ + Fore.RESET)    
    
room1() # CALLING ROOM1() SO THAT THE GAME STARTS. EVERYTHING COMES BEFORE THIS CLAUSE.


