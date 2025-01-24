# ProfileWindow - A floating console to interact with your other profiles

### Author: Humera

### Information
ProfileWindow allows you to view and interact with your other profiles without needing to use MultiView.
To use, install ProfileWindow on all of your profiles that you wish to see, as well as your main profile.
Then simply type `pwadd <profileName>` to open a floating window showing the output of that profile!

Example:
I have 2 profiles, Humera and Kryomeris. I wish Humera to be my primary profile.
I install ProfileWindow for both profiles, then in the Humera profile I type `pwadd Kryomeris`.

When used in conjunction with the convertToUserWindow package, these windows can be popped out from
your Mudlet window to be dragged anywhere you wish.

### Commands (Aliases)
`pwadd <profileName>`    - Opens a new ProfileWindow to view 

### Known Issues
When closing a ProfileWindow, if the command line in that window has focus then clicking in the area
previously occupied by your floating window will show just the MiniConsole with no way to close it
again without a `resetProfile()`