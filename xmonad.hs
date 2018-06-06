import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Hooks.FadeInactive
import Data.List

main = xmonad defaultConfig
     { terminal    = "gnome-terminal"
     , handleEventHook = docksEventHook <+> handleEventHook defaultConfig
     , normalBorderColor = "#0c1021" -- color of non-focused borders
     , focusedBorderColor = "#fbde2d" -- color of focused borders
     , startupHook = spawn "~/.xmonad/autostart.sh"
     , layoutHook = myLayoutHook
     -- ^ let the layout make space for bars
     , manageHook = myManageHook
     , logHook = myLogHook
     }

myLayoutHook = avoidStruts (tiled ||| Mirror tiled) ||| Full
  where
    tiled = smartSpacing 4 -- het aantal pixels tussen windows
          $ Tall nmaster delta ratio
    nmaster = 1
    ratio = 3/5
    delta = 2/100

myManageHook = composeAll [ title =? "Float" --> doFloat
                          , className =? "HardwareSimulatorMain" --> doFloat
                          , className =? "processing-app-Base" --> doFloat
                          , className =? "feh" --> doFloat
                          , stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
                          , className =? "Stopwatch" --> doFloat ]

isSubstringOf :: String -> String -> Bool
isSubstringOf (x:xs) [] = False
isSubstringOf xs ys
    | isPrefixOf xs ys = True
    | isSubstringOf xs (tail ys) = True
    | otherwise = False

myLogHook = fadeOutLogHook
            (fadeIf (fmap (isSubstringOf "Your library") title <||> title =? "Hangout Video Call")
             0.75)
