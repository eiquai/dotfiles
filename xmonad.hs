import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers
--import XMonad.Hooks.EwmhDesktops as EwmhDesktop --ambigous with fullscreenEventHook
import XMonad.Util.Paste
import XMonad.Util.NamedWindows
import XMonad.Util.Run(spawnPipe, safeSpawn)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders(noBorders, smartBorders)
import XMonad.Layout.Fullscreen
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.ToggleLayouts
import XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86
import System.IO
import Data.Ratio ((%))

-- molokai color scheme
-- To Do: document which color scheme is used and where it is located to prepare for easy changes
-- dark grey:   #272822
-- pink:        #F92672
-- blue:        #66D9EF
-- green:       #A6E22E
-- ocker:       #FD971F


-- mod keys:
-- mod1mask -> [alt left]
-- mod4mask -> [super]

-- VARIABLES FOR XMOBAR
myTitleColor        =   "#272822"
myTitleLength       =   60
myCurrentWSColor    =   "#F92672"
myVisibleWSColor    =   "#66D9EF"
myUrgentWSColor     =   "#F92672"
myUrgentWSLeft      =   "!"
myUrgentWSRight     =   "!"
myVisibleWSLeft     =   "("
myVisibleWSRight    =   ")"
myCurrentWSLeft     =   "["
myCurrentWSRight    =   "]"

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name        <- getName w
        Just idx    <- fmap (W.findTag w) $ gets windowset
        safeSpawn "notify-send" [show name, "workspace" ++ idx]

myManageHook = floatHook <+> fullscreenManageHook <+> manageScratchPad

floatHook = composeAll
    [ className =? "Gimp-2.8"   --> doFloat
    , resource =? "synapse" --> doIgnore
    , resource =? "arandr" --> doFloat
    , resource =? "keepassx2" --> doFloat
    , resource =? "skype" --> doFloat
    , resource =? "gnome-calendar" --> doFloat
    , resource =? "gnome-control-center" --> doFloat
    , resource =? "gnome-weather" --> doFloat]

manageScratchPad::ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)

    where

    h = 0.6
    w = 0.6
    l = 0.2
    t = 0.4

myStartupHook ::X ()
myStartupHook = do
     spawn "compton -f -I 0.10 -O 0.10 --backend glx --vsync opengl"
 
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
--withUrgencyHook LibNotifyUrgencyHook <- This still is ToDo!

myPP = xmobarPP
            { ppCurrent = xmobarColor "#F92672" "" . wrap "[" "]"
            , ppTitle = xmobarColor "#F92672" "#272822" . shorten myTitleLength}

--myPP = xmobarPP
--             { ppTitle = xmobarColor "#F92672" "#272822" . shorten myTitleLength
--             , ppCurrent =   xmobarColor myCurrentWSColor "" . wrap myCurrentWSLeft myCurrentWSRight
--             , ppVisible =   xmobarColor myVisibleWSColor "" . wrap myVisibleWSLeft myVisibleWSRight 
--             , ppUrgent  =   xmobarColor myUrgentWSColor  "" . wrap myUrgentWSLeft myUrgentWSRight 
--             }

myBar = "xmobar ~/dotfiles/xmobarrc"

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_m)

myConfig = def {
        manageHook      = ( isFullscreen --> doFullFloat ) <+> manageDocks <+> myManageHook <+> manageHook def
        , startupHook   = myStartupHook <+> startupHook def
        , handleEventHook   =   handleEventHook def <+> fullscreenEventHook
        , layoutHook    = avoidStruts $ toggleLayouts (noBorders Full) $ smartBorders $ layoutHook def
        , modMask                 = myModMask
        , terminal                = myTerminal
        , XMonad.workspaces       = myWorkSpaces
    
        --appearance
        , borderWidth           = myBorderWidth
        , normalBorderColor     = myNormalBorderColor
        , focusedBorderColor    = myFocusedBorderColor
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "physlock -ds")
        , ((mod1Mask        , xK_space), spawn "/home/timon/dotfiles/bin/layout_switch")
        , ((mod4Mask            , xK_m), sendMessage ToggleStruts)
        , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1%")
        , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1%")
        , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ((controlMask .|. mod1Mask, xK_t), spawn myTerminal)
        , ((mod1Mask .|. shiftMask, xK_comma), scratchpad) --urxvt quake-style
        , ((controlMask, xK_space), spawn "synapse")
        , ((0, xF86XK_Tools), spawn "systemctl suspend")
        , ((0, 0x1008FF21), spawn "systemctl suspend")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod1Mask.|. shiftMask, xK_l), spawn "playerctl next")
        , ((mod1Mask.|. shiftMask, xK_h), spawn "playerctl previous")
        , ((mod1Mask.|. shiftMask, xK_space), spawn "playerctl play-pause")
        , ((0, xK_Insert), pasteSelection) -- there is a problem here, as it seems to escape some characters
        ]

    where

    scratchpad = scratchpadSpawnActionTerminal myTerminal

myTerminal              = "urxvt"
myModMask               = mod4Mask -- [super]
myBorderWidth           = 1
myNormalBorderColor     = "#e0e0e0"
myFocusedBorderColor    = "#F92672"
myWorkSpaces    = [ "1:<fn=1>\xf268</fn>", "2:<fn=1>\xf120</fn>", "3:<fn=1>\xf001</fn>", "4:<fn=1>\xf2b6</fn>", "5:<fn=1>\xf269</fn>", "6:calc", "7:misc", "8:misc", "9:misc"]
