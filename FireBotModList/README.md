This is a mod that will allow a firebot command to display your active mods.

# setup
## balatro
Make sure you have [Steamodded](https://github.com/Steamodded/smods) and [lovly](https://github.com/ethangreen-dev/lovely-injector) installed.
Add BalatroFireBotModList to your mods folder and launch the game.
You can test if it's working by opening a terminal and running:
```
 curl http://localhost:8080/mods
```
The output should look something like this:
![image](https://github.com/user-attachments/assets/ea15d0a2-f523-4a7d-ba5e-f32ed2df7f0a)
Specifically, the "Content" should be your active mods.
If you see your mods, then you're done on the Balatro side.
## FireBot
First, ensure that you have Firebot set up and working.
Next, go to commands and create a new custom command.
Make the trigger !mods or something similar.
Fill the description with something like "List active mods in Balatro when in game."
Switch to advanced mode.
Under restrictions, add a new restriction, select category/game, add it then search for Balatro.

![image](https://github.com/user-attachments/assets/1464663b-1a4f-4833-9111-e95a3af5c989)

Next, add a new effect.
Search for HTTP Request

![image](https://github.com/user-attachments/assets/1cacae78-3d72-4c5e-b8e7-47939aff4b2e)

Set the URL to "http://localhost:8080/mods" and the method to get.

![image](https://github.com/user-attachments/assets/b66f4b79-5b0b-4a3a-97b5-bcb2566bde97)

(Optional) Add a run effect on error, search for Chat and add an error message.

Save the changes and add a new effect. search for chat and set the "message to send" to "$effectOutput[httpResponse]" and save

![image](https://github.com/user-attachments/assets/1caa8217-9a84-48ce-8bb9-720230087b8c)

Everything is now done and ready for testing.
Go live, launch Balatro and run your command.
The output should look something like this:

![image](https://github.com/user-attachments/assets/46da12a9-4244-402a-b50e-1f2bf54fda1f)
