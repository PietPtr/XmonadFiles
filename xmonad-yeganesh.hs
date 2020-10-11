import XMonad
import XMonad.Hooks.ManageDocks  (ToggleStruts(..),avoidStruts,docks,manageDocks)
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Hooks.FadeInactive
import XMonad.Layout.NoBorders
import Data.List
import qualified Data.Map as M

main = xmonad $ docks defaultConfig
     { terminal    = "xterm"
     , normalBorderColor = "#070a14" -- color of non-focused borders
     , focusedBorderColor = "#fbde2d" -- color of focused borders
     , startupHook = spawn "~/.xmonad/autostart.sh"
     , layoutHook = myLayoutHook
     -- ^ let the layout make space for bars
     , manageHook = myManageHook
     , logHook = myLogHook 
     , keys = \c -> myKeys c `M.union` keys defaultConfig c
     } 

myLayoutHook = avoidStruts (tiled ||| Mirror tiled) ||| noBorders Full
  where
    tiled = smartSpacing 3 -- het aantal pixels tussen windows
          $ Tall nmaster delta ratio
    nmaster = 1
    ratio = 3/5
    delta = 2/100

myManageHook = composeAll [ title =? "Float" --> doFloat
                          , className =? "HardwareSimulatorMain" --> doFloat
                          , className =? "processing-app-Base" --> doFloat
                          , className =? "feh" --> doFloat
                          , className =? "SpaceEngine.exe" --> doFloat
                          , stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat]

isSubstringOf :: String -> String -> Bool
isSubstringOf (x:xs) [] = False
isSubstringOf xs ys
    | isPrefixOf xs ys = True
    | isSubstringOf xs (tail ys) = True
    | otherwise = False

myLogHook = fadeOutLogHook
            (fadeIf (fmap (isSubstringOf "Spotaoeuoaeuify") title <||> title =? "Hangout Video Call")
             0.58)

myKeys (XConfig {modMask = modm}) = M.fromList $
    [ ((modm, xK_p), spawn "$(yeganesh -x -- -nb \"#0c1021\" -nf \"#ffffff\" -sb \"#0c1021\" -sf \"#fbde2d\" -fn miscfixed:size=10:style=SemiCondensed )") ]

