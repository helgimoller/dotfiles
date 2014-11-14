import XMonad 

import Data.Monoid
import Data.List (intercalate, concat)
import Control.Monad
import Control.Monad.IO.Class

import XMonad.Hooks.ManageDocks --(manageDocks, avoidStruts, ToggleStruts)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Prompt
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing     
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import DBus
import DBus.Client
import System.Taffybar.Hooks.PagerHints (pagerHints)
import System.Taffybar.XMonadLog (dbusLogWithPP, taffybarDefaultPP, taffybarColor, taffybarEscape)

myTerminal           = "gnome-terminal"
myFocusFollowsMouse  = False
myClickJustFocuses   = False
myBorderWidth        = 2
myModMask            = mod4Mask
myNormalBorderColor  = "#242424"
myFocusedBorderColor = "#C75646"

myKeys               = 
    [ (("M-C-b"), sendMessage $ ToggleStruts )
    , (("M-q"  ), spawn myRestart )  
    , (("M-n"  ), spawn myToggleKeyboardLayout )  
    ]
--
--myMouseBindings      =
myWorkspaces         = ["dev","web","chat","misc","video","music","VII"] 
myLayout             = avoidStruts (tiled_space ||| tiled ||| mirror_space ||| mirrored ||| full) ||| fullnoborder
    where
            tiled_space   = spacing 20 $ Tall nmaster delta ratio
            tiled         = Tall nmaster delta ratio
            mirrored      = Mirror (Tall nmaster delta ratio)
            mirror_space  = spacing 20 $ Mirror (Tall nmaster delta ratio)
            full          = Full
            fullnoborder = noBorders (fullscreenFull Full)
            --Default number of windows in master pane:
            nmaster = 1

            --Default proportion of screen occupied by master pane:
            ratio = 5/8

            --Percent of screen to increment by when resizing panes
            delta = 5/100 

-- Key binding to toggle the gap for the bar

--myEventHook          = mempty
myStartupHook        = do
    spawn "xmodmap ~/.xmodmaprc"
    spawn "xbindkeys"
    spawn "/home/helgi/.bin/xsettings.sh"

myManageHook         = manageDocks <+> composeAll
    [ 
      className =? "Firefox"   --> doShift "web"
    , className =? "mpv"       --> doShift "video"
    , className =? "Deluge"    --> doShift "misc"
    , className =? "HipChat"    --> doShift "chat"
    , className =? "Vpnui"    --> doShift "misc"
    , className =? "clementine"    --> doShift "music"
    ]

--Manually handle the recompilation while killing the statusbar.
-- nm-applet doesnt like being started multiple times.
applets = ["taffybar", "nm-applet", "firewall-applet"]
killing = intercalate " && " $ map (\x -> " pkill -KILL " ++ x) applets
myRestart = killing ++ " && xmonad --recompile && xmonad --restart"

-- Switch keyboard layouts
myToggleKeyboardLayout = "/home/helgi/.bin/kb_toggle.sh"

main = do
    client <- connectSession
    let pp = defaultPP
    xmonad    
        $ ewmh $ pagerHints 
        $ defaultConfig { 
            -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            clickJustFocuses   = myClickJustFocuses,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,

            -- key bindings
            --mouseBindings      = myMouseBindings,

            -- hooks, layouts
            logHook            = dbusLogWithPP client pp,
            layoutHook         = myLayout,
            manageHook         = myManageHook,
            workspaces         = myWorkspaces,
            --handleEventHook    = myEventHook,
            startupHook        = myStartupHook
             
        } `additionalKeysP` myKeys
