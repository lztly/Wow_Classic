SlashHelp
by SDPhantom
http://www.phantomweb.org
===================================================================================================

For questions and bug reports go to the "Contact Me" section of my website and fill out the form.
Use at your own risk, but if anything serious should happen, blame Blizzard's crappy script engine.

Instructions: UnZip the contents into World of Warcraft's "Interface\AddOns" folder.

===================================================================================================
Use:	When a slash is entered as the first character of the chat edit box, a scrollable list
	of commands pops up over the chat frame. Entering additional text will update the list,
	filtering it by the text entered.





API Implementation:

SlashHelp:SetOwner(EditFrame)	- Sets EditFrame as the new owner of the command list.
				- EditFrame is a pointer to the EditBox frame itself.
				- The command list attaches to its owner and positions itself accordingly.
					(Suggested use, run from the OnEditFocusGained event)

SlashHelp:ClearOwner(EditFrame)	- If the command list is owned by EditFrame, clear/hide display.
				- EditFrame is a pointer to the EditBox frame itself.
					(Suggested use, run from the OnEditFocusLost event)

SlashHelp:SetFilter(Text)	- Displays the command list filtered by Text.
				- Text must be a string contain a slash, "/", as the first character.
				- Owner must be set prior to applying a filter. Does nothing if Owner isn't set.
					(Suggested use, run from the OnTextChanged and/or OnTextSet events)

===================================================================================================
Versions:
--= Public Release =--

	v4.2 (2012-09-26)	(Interface 50001)
		Minor Bugfix
			-Quick patch to the scanner fixes an unhandled error with some addons.

	v4.1 (2011-11-29)	(Interface 40300)
		WoW v4.3.0 Support
			-Quick patch to the scanner fixes a conflict with Blizzard's new slash command code.

	v4.0 (2010-11-04)	(Interface 40000)
		Complete Rewrite
			-Tested for Cataclysm v4.0.3
			-New multi-stage command scanner for optimized run-time performance
				*Initial scanner scans for all slash commands on-load (chat, emote, secure, and normal).
				*Progressive scanner loads additional commands as they are registered.
				*Filter runs as you type, filtering through a presorted cache.
			-Scanners cache and sort only when new commands added.
			-Sort and type filter preferences are now saved across sessions.
			-Tooltips display token identifier, chat type, aliases, and if available, addon information.
			-Clean client runs new filter at 2ms, compared to 280ms that v3.1 ran at

	v3.1 (2010-09-08)
		Minor Bugfix
			-Configuration window works properly again.
				(Didn't reference far enough back to update listing)
			-Corrected version number in TOC file.

	v3.0 (2010-08-06)	(Interface 30300)
		WoW v3.3.5 Support
			-New display code allows the command list to be shared among multiple edit boxes.
			-New scroll indicator shows position in the list.
			-API for AddOn support partially implemented.
				(Custom positioning not supported)

	v2.2 (2008-11-03)
		Minor Bugfix
			-Made the slash command detection a little more robust.
			-Completely removed auto-complete.
				(You can hit Tab to have the default UI do this.)

	v2.1 (2008-08-16)
		Minor Optimizations
			-Changed a few string function calls to the object-oriented style.
				(Slightly shorter codebase.)

	v2.0 (2007-08-18)
		Core Rewrite
			-Remade detection code to scan through the slash globals instead of
				from the function table.
			-Removed auto-complete ability from secure commands.
				(Sets off Blizzard's taint code)

	v1.1 (2006-12-10)	(Interface 20000)
		WoW v2.0.1 Support
			-Added the new secure slash commands implemented by Blizzard.

	v1.0 (2006-11-20)
		Initial Version
			-Scans and detects all emotes, chat types, and slash commands.
				(Even those registered by other addons)
			-Option to sort alphabetically or by command type.
			-Able to filter by type. (Emote, Chat, or Command)
			-Scrollable list of found commands.
			-Autocomplete feature implemented when a command from the list is clicked
				or the search returns only one command.
				(Does not execute command until Enter is pressed)
