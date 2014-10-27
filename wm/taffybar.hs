import System.Taffybar 
import System.Taffybar.Systray 
import System.Taffybar.TaffyPager 
import System.Taffybar.SimpleClock 
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.MPRIS
import System.Taffybar.Battery

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU

import Graphics.UI.Gtk.General.RcStyle (rcParseString)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

font       = "Envy Code R 10"
bgColor    = "#242424"
fgColor    = "#5D5D5D"
textColor  = "#F7F7F7"
bgPrelight = "#C75646"
fgPrelight = "#5D5D5D"
activeFg   = "#CDEE60"

main = do

    let memCfg = defaultGraphConfig { graphDataColors = [(0.78, 0.38, 0.274, 1)]
                                    , graphLabel = Just "mem"
                                    }
        cpuCfg = defaultGraphConfig { graphDataColors = [ (0.8, 0.93, 0.6, 1) , (0.8, 0.93, 0.6, 0.5) ]
                                    , graphLabel = Just "cpu"
                                    }
    let clock = textClockNew Nothing "<span fgcolor='#CDEE69'>%a %b %_d %H:%M:%S</span>" 1
	batt  = batteryBarNew defaultBatteryConfig 1
        mpris = mprisNew
        mem   = pollingGraphNew memCfg 1 memCallback
        cpu   = pollingGraphNew cpuCfg 0.5 cpuCallback
        tray  = systrayNew
        pager = taffyPagerNew defaultPagerConfig


    rcParseString $ ""
        ++ "style \"default\" {"
        ++ "    font_name      = \"" ++ font       ++ "\""
        ++ "    bg[NORMAL]     = \"" ++ bgColor    ++ "\""
        ++ "    bg[PRELIGHT]   = \"" ++ bgPrelight ++ "\""
        ++ "    fg[NORMAL]     = \"" ++ fgColor    ++ "\""
        ++ "    fg[PRELIGHT]   = \"" ++ fgPrelight ++ "\""
        ++ "    text[NORMAL]   = \"" ++ textColor  ++ "\""
        ++ "}"
        ++ "style \"active-window\" {"
        ++ "    bg[NORMAL]     = \"" ++ bgColor    ++ "\""
        ++ "    fg[NORMAL]     = \"" ++ activeFg   ++ "\""
        ++ "}"
    defaultTaffybar defaultTaffybarConfig { startWidgets  = [ pager ]
                                          , endWidgets    = [ tray, batt, clock, mem, cpu ]
                                          , monitorNumber = 2
                                          , barHeight     = 20
                                          , barPosition   = Top
    }
    defaultTaffybar defaultTaffybarConfig { startWidgets  = [ mem, cpu ]
                                          , endWidgets    = [ tray, mpris]
                                          , monitorNumber = 2
                                          , barHeight     = 20
                                          , barPosition   = Bottom
    }
