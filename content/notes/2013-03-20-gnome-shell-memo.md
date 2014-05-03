---
title: Gnome Shell Memo
kind: note
created_at: 2013-03-20 12:00:00 +0200
published: false
---
# Post Installation Configuration
* Remove overlay scrollbars (`sudo apt-get remove overlay-scrollbar*`)
* Install Useful Applications [see after](#useful-apps)
* Install Useful Extensions [see after](#useful-exts)

# <a id="useful-apps"></a>Useful Applications
* Gnome Tweak Tool ([apt](apt://gnome-tweak-tool))

# <a id="useful-exts"></a>Useful Extensions
* __alternate tab__ &mdash; (allows you to navigate through all current instances of the same application in the normal flow)
* dash to dock &mdash; (makes the Gnome Shell intellihide and closer to a classical dock)
* remove accessibility &mdash; (remove useless accessibility icon)
* media player indicator &mdash; (allows you to easily control your media player through sound volume icon (or dedicated one))
* antisocial menu &mdash; (remove useless informations about yourself)
* __user themes__ &mdash; (allows you to add new manage Gnome Shell themes)
* advanced settings &mdash; in user menu (place a shortcut to Gnome Tweak Tool after the default System Settings)
* __panel settings__ &mdash; (allows you to place panel to bottom, auto hide, &#8230;) [see after](#panelSettings-setup)

## <a id="panelSettings-setup"></a>Panel Settings Special Case
It seems that the panel settings extension doesn't work out of the box using the [Gnome Shell Extensions site](https://extensions.gnome.org/) (at least on Ubuntu 12.10).
Moreover, the search for *panel* doesn't returns anything relevant despite the actual extension name&#8230;

You can access it through a direct URL: [extension/208/panel-settings/](https://extensions.gnome.org/extension/208/panel-settings/)

The install switch seems to be not working certainly due to Gnome Shell version restrictions. The procedure is explained in comments:

1. `git clone git://github.com/eddiefullmetal/gnome-shell-extensions.git`
2. `cp -r ./gnome-shell-extensions/panelSettings@eddiefullmetal.gr ~/.local/share/gnome-shell/extensions` (ensures `metadata.json` contains a compatible Gnome Shell version)
3. restart Gnome Shell
