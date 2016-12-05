import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run
import System.IO

myLayout = desktopLayoutModifiers $ tiled ||| Mirror tiled ||| noBorders Full ||| Full  
  where  
      -- default tiling algorithm partitions the screen into two panes  
      tiled = Tall nmaster delta ratio  

      -- The default number of windows in the master pane  
      nmaster = 1  

      -- Default proportion of screen occupied by master pane  
      ratio = 1/2  

      -- Percent of screen to increment by when resizing panes  
      delta = 2/100  

main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/severus/.xmobarrc"
xmonad $ desktopConfig
	{ manageHook = composeAll [
		manageDocks,
		isFullscreen --> doFullFloat,
		manageHook defaultConfig
	  ]
	, layoutHook = myLayout-- smartBorders . avoidStruts $ layoutHook defaultConfig
	, handleEventHook = fullscreenEventHook <+> handleEventHook desktopConfig
	, logHook = dynamicLogWithPP xmobarPP
		{ ppOutput = hPutStrLn xmproc
		, ppTitle = xmobarColor "red" "" . shorten 20
		}
	}
