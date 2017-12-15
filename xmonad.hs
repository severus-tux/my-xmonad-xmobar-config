import XMonad

import XMonad.Config.Desktop

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid



import XMonad.Util.Run
import XMonad.Util.EZConfig

import Data.List 

import System.IO

import Control.Monad (liftM2)
import qualified XMonad.StackSet as W


layoutHook'  =  onWorkspaces ["4:vlc"] vlcLayout $
				onWorkspaces ["1:main"] myLayout2 $ 
                --onWorkspaces ["6:gimp"] gimpLayout $ 
                --onWorkspaces ["4:chat"] imLayout $
                myLayout

myLayout = desktopLayoutModifiers $ noBorders Full   ||| Mirror tiled ||| tiled   
  where  
      -- default tiling algorithm partitions the screen into two panes  
      tiled = Tall nmaster delta ratio  

      -- The default number of windows in the master pane  
      nmaster = 1  

      -- Default proportion of screen occupied by master pane  
      ratio = 1/2  

      -- Percent of screen to increment by when resizing panes  
      delta = 2/100  

myLayout2 = desktopLayoutModifiers $  tiled |||  Mirror tiled |||   noBorders Full
  where  
      -- default tiling algorithm partitions the screen into two panes  
      tiled = Tall nmaster delta ratio  

      -- The default number of windows in the master pane  
      nmaster = 1  

      -- Default proportion of screen occupied by master pane  
      ratio = 1/2  

      -- Percent of screen to increment by when resizing panes  
      delta = 2/100  

--gimpLayout  = avoidStruts $ withIM (0.11) (Role "Toolbox") $
--              reflectHoriz $
--              withIM (0.15) (Role "gimp-dock") Full

vlcLayout = avoidStruts $  noBorders Full 
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []

myTerminal = "terminator"
myWorkspaces    = ["1:main","2:web","3:emacs", "4:vlc"  , "5:files" , "6:gimp" , "7" , "8" , "9" ]

myManageHook = composeAll
	   [ className =? "Firefox" --> viewShift "2:web"
	   , className =? "Terminator" --> viewShift "1:main"
	   , className =? "Vlc" --> viewShift "4:vlc"
	   , className =? "Gedit" --> viewShift "3:emacs"
	   , className =? "Nautilus" --> viewShift "5:files"
	   , className =? "Emacs" --> viewShift "3:emacs"
	   , className =? "Gimp" --> viewShift "6:gimp"
	   , className =? "Xmessage"  --> doFloat
	   , manageDocks
	   , isFullscreen --> doFullFloat
	   ]
   where viewShift = doF . liftM2 (.) W.greedyView W.shift
   
main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/severus/.xmobarrc"
xmonad . docks $ desktopConfig
	{ manageHook    = myManageHook <+> manageHook defaultConfig -- uses default too
	--manageHook = composeAll [	manageDocks, isFullscreen --> doFullFloat, manageHook desktopConfig ]
	, layoutHook = layoutHook'--myLayout-- smartBorders . avoidStruts $ layoutHook defaultConfig
	, handleEventHook = fullscreenEventHook <+> handleEventHook desktopConfig
	, logHook = dynamicLogWithPP xmobarPP
		{ ppOutput = hPutStrLn xmproc
		, ppTitle = xmobarColor "red" "" . shorten 20
		}
    , modMask     = mod4Mask
    , workspaces          = myWorkspaces
    , terminal = myTerminal
}
