***********************************************************************
SmartAuraWatch
Created by Aeldra (EU-Proudmoore)
***********************************************************************

The addon will notify you with an icon, time left, charges and target 
of the aura that has procced. It is possible to monitor several auras
on different targets at the same bar.
It provides also a handy default set of proccs for each class.


- Features -
* Up to 9 bars
* Up to 9 icons per bar at the same time
* Powerful filter options for each aura
  - Target Unit (Player, Traget, Focus, etc.)
  - Aura Duration < and >
  - Aura Charges < and >
  - Harmful / Helpful / etc.
  - Friendly / Enemy
  - Talent Tree
  - Not active check
  - All the time or only in combat
  - All or only own
* Alert sound
* Ease and slim setup
* Supports totems
* Supports temporary enchants
* Supports all clients
* Supports ButtonFacade
* Supports up to 10 custom sounds (sound folder)


- FAQ -
Q1: How can I configure SmartAuraWatch?
A1: Type in the chat "/saw" or "/smartaurawatch" to open the options frame.

Q2: Why does my aura not show up?
A2: Please check the spelling, aura names are case sensitive.

Q3: Why does my aura not show up, when I it is not active, but the option is set?
A3: If the aura is added with the name and it is not a spell in your book, 
    the icon is not available at creation time. SmartAuraWatch updates itself
    when the aura is the first time active.
    
Q4: How can I move the bars?
A4: Open the options frame. One icon of each bar has a yellow background/boarder, this one can be moved.

Q5: Can I use the spell id?
A5: Enter the spell id in the textbox, press enter and if it is a valid id the name will be displayed.

Q6: Why does show a question mark for the aura in the options frame?
A6: If the aura is added with the name and it is not a spell in your book, 
    the icon is not available at creation time. SmartAuraWatch updates itself
    when the aura is the first time active.
    
Q7: How can I change the font?
A7: Use the chat command '/saw f <font path>', example:
    /saw f Interface\Addons\SharedMedia\fonts\impact.ttf
    
Q8: How can I monitor totems?
A8: Simply enter the totem name as aura name.
    
Q9: How can I monitor weapon buffs?
A9: Enter the item name or inventory slot name as aura name, like 'Main Hand', 'Off Hand', 'Thrown'.
    The slot name is localized, so use the offical slot name in your language.
    The filter is set per default to 'Enchant'.
    
Q10: How can I monitor inventory item cooldowns?
A10: Enter the item name or inventory slot name as aura name, like 'Trinket 1', 'Hand', 'Waist'.
     The slot name is localized, so use the offical slot name in your language.
     The filter is set per default to 'Cooldown'.
     
Q11: How can I add custom sounds?
A11: Put your custom sound files (up to 10) in the sound folder.
     The rules:
     1. The files have to be encoded as MP3
     2. You MUST name the files as sound1.mp3, sound2.mp3 and so on.
     If you do not follow these rules, they will NOT play!     


- Chat -
Type /saw [command] or /smartaurawatch [command] in game
reset    - Reset local settings to default
resetall - Reset ALL settings to default
o        - Default Orientation
is #     - Default Icon size #value (20-80)
g #      - Default Growth #value (0-2)
v #      - Default Visibility #value (0.0-1.0)
f []     - Default Font [font path]
fso #    - Default font size offset #value (-20-20)
frs      - Reset to default font
srs      - Reset all Statistics


- To Do -
* Missing/incomplete translations (FR/ES/RU/koKR/zhTW)
* Complete default aura list for each class
Your help would be very appreciated :)


- Contact -
Please send me a mail or write a comment if you discover Bugs or have Suggestions.
aeldra@sonnenkinder.org 


***********************************************************************


Changes: 
Rev     Date        Description
------  ----------  -----------------------
1.13.2a 2019-09-07  Inital WoW Classic release

7.0a    2016-08-16  Updated TOC

6.0c    2014-12-02  Added 'Button Spacing' slider in the global options, adjusts the spacing between two buttons

6.0b    2014-10-23  Added Masque support

6.0a    2014-10-16  Updated code for Warlords of Draenor

5.4b    2013-10-30  Fixed LUA errors with RealmName

5.4a    2013-09-12  Fixed LUA errors with sliders
                    Updated Korean localization, thanks to Nfrog
                    Updated TOC

5.1a    2012-12-21  Added new global option: 'Blizzard Timer Style'
                    Updated TOC

5.0c    2012-10-12  Updated global cooldown detection
                    Disabled check during pet battle

5.0b    2012-09-01  Fixed possible 'taint' issue in combination with the Glyph UI
                    Fixed graphical bar issue

5.0a    2012-08-28  Updated code for Mists of Pandaria
                    Due to I am moving to a new town, my online access and spare time is limited. This release will restore basic functionality, but unfortunately it will not contain all the buff changes, sorry.
                    Please report any missing buffs, thanks!
                    
4.3a    2011-11-30  Added chat command '/saw t' to toggle temporary SAW on/off
                    Added 'Full seconds' global option, to display seconds as integer numbers
                    Added feature to display the cooldown of a spell and when it is ready again. Just set the aura filter to 'Cooldown'
                    Updated auto filter detection for trinkets
                    Updated TOC

4.2a    2011-06-29  Updated Aura Scan
                    Updated TOC

4.1c    2011-05-04  Fixed bar statistics texture
                    Fixed possible LUA error with bar modes

4.1b    2011-05-01  Fixed Aura Scan issue

4.1a    2011-04-28  Added 'Global Options' button and frame
                    Added new bar styles
                    Added options: 'Show Icon Border', 'Show Bar Spark', 'Font Size Offset'
                    Added support for up to 10 custom sounds (sound folder)
                    Updated TOC

4.0g    2011-03-23  Fix repositioning issue, if tooltip is enabled
                    Added bar support (vertical & horizontal) as orientation option
                    Added 'Mouseover' and 'Arena 1-5' to the target unit list
                    Added ButtonFacade support
                    Updated status bar texture
                    Updated memory optimization
                    Updated localization

4.0f    2011-03-13  Alert sound set on the 'Master' sound channel, to play it even if the game fx sound is off
                    Added 'Tooltips' option, to activate aura tooltips on this bar
                    Added statistics chat report functionality (notes icon)
                    Added Data Broker support
                    Added display of statistics without open options frame (Data Broker)

4.0e    2011-03-03  Fixed possible editing issue for auras
                    Inventory items can now also added by name
                    Added monitoring of inventory cooldowns, use the item name or inventory slot name (Trinket 1, Hands, Waist) as aura name
                    Added 'Statistics' frame/list, to show in combat uptime for each aura
                    Added 'Stat' button, to show statistics frame for each bar
                    Added 'Colored' option, displays colored time left numbers
                    Added 'Enchant' and 'Cooldown' filter for inventory items
                    Added chat command '/saw srs' to reset all statistics

4.0d    2011-02-27  Fixed display issue for auras without a duration or expiration time
                    Fixed display issue for auras with a duration > 100sec
                    Updated display for auras with a duration > 100sec (in minutes and light green)
                    Added monitoring of totems, use the totem name as aura name
                    Added monitoring of temporary enchants (weapon buffs), use the inventory slot name as aura name (Main Hand, Off Hand, Thrown)
                    Added 'Pet' to the target unit list
                    Added 'Aura Scan' option, to collect auras during combat and to built up the selection list
                    Added 'Aura Scan' frame/list, to add ease new auras from the selection list

4.0c    2011-02-21  Added mini aura icon and tooltip in options frame
                    Added chat commands:
                    /saw f <>   - Font <font path>
                    /saw fso #  - Font size offset #value
                    /saw frs    - Reset to default font

4.0b    2010-02-15  Added show cooldown option

4.0a    2011-02-09  Initial version of SmartAuraWatch
