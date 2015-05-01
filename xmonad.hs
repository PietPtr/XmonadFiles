import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Layout.Spacing
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Scratchpad
import XMonad.Actions.SpawnOn
import XMonad.Actions.WithAll
import XMonad.Actions.Warp
import XMonad.Util.Run

main =
  xmonad $ defaultConfig
    { terminal              = myTerminal
    -- , modMask               = myModMask
    , workspaces            = withScreens 2 
                                   ["1","2","3","4","5","6","7","8","9","0"]
    , borderWidth           = myBorderWidth
    , normalBorderColor     = myNormalBorderColor
    , focusedBorderColor    = myFocusedBorderColor
    , keys                  = newKeys
    , startupHook           = spawn "~/.xmonad/autostart.sh"
    , layoutHook            = myLayoutHook
    , logHook               = myLogHook
    , manageHook            = myManageHook
    }

myTerminal = "urxvtc"
-- myModMask = mod4Mask -- Win key or Super_L
myLayoutHook = avoidStruts (smartBorders tiled) 
           ||| avoidStruts (smartBorders $ Mirror tiled) 
           ||| noBorders Full 
  where  
    tiled = smartSpacing 4 $ Tall nmaster delta ratio  
    nmaster = 1  
    ratio = 3/5  
    delta = 2/100  

myLogHook = fadeInactiveLogHook 0.90

myManageHook = composeAll
               [ title =? "Float" --> doFloat ]

-- Visual
myBorderWidth           = 2
myNormalBorderColor     = "#121216"
myFocusedBorderColor    = "#D55362"


-- Key Bindings
defKeys    = keys defaultConfig
delKeys x  = foldr M.delete           (defKeys x) (toRemove x)
newKeys x  = foldr (uncurry M.insert) (delKeys x) (toAdd    x)
    -- remove some of the default key bindings
toRemove conf@(XConfig {XMonad.modMask = modm}) =
    -- Swap terminal and swapMaster
    [ (modm              , xK_Return)
    , (modm .|. shiftMask, xK_Return)
    ]
    -- These are my personal key bindings
toAdd conf@(XConfig {XMonad.modMask = modm}) =
    -- swap terminal and swapMaster
    [ ((modm              , xK_Return   ), spawnHere $ terminal conf        )
    , ((modm .|. shiftMask, xK_Return   ), windows W.swapMaster             ) 
    -- Add firefox keybinding
    , ((modm              , xK_b        ), spawnHere "firefox"              )
    -- Add emacs keybind
    , ((modm              , xK_m        ), spawnHere "emacs"                )
    -- Scratchpad Keybinding
    , ((modm              , xK_x        ),
                      scratchpadSpawnActionCustom "urxvtc -name scratchpad" )
    -- Push all floats back in tiling
    , ((modm .|. shiftMask, xK_t        ), sinkAll                          )
    -- Hide cursor in corner of screen
    , ((modm .|. shiftMask, xK_b        ), banishScreen UpperLeft           )
    -- Disable and enable compton
    , ((modm              , xK_n        ), spawn "killall compton"          )
    , ((modm .|. shiftMask, xK_n        ), spawn "compton"                  )
    -- Next and previous in mpd
    , ((modm .|. shiftMask, xK_comma    ), spawn "mpc prev"                 )
    , ((modm .|. shiftMask, xK_period   ), spawn "mpc next"                 )
    -- Play / pause in mpd
    , ((modm              , xK_slash    ), spawn "mpc toggle"               )
    ]
    ++
    [((m .|. modm, k), windows $ onCurrentScreen f i)
    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
