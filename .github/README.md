<div align="center">
     <h1>  [ ii-vynx hyprland dots ] </h1>
</div>



<div align="center"> 
     <h2>• screenshots •</h2>

|  |  |
| ----------- | ----------- |
| <img width="1919" height="1078" alt="image" src="https://github.com/user-attachments/assets/9297bec7-63b4-47bf-8905-9a4baa8de4e9" /> | <img width="1916" height="1078" alt="image" src="https://github.com/user-attachments/assets/53c3b4be-9ba0-40dc-8570-c6a3a80c18cf" /> |  

| Media mode | Sharp style |
| ----------- | ----------- |
| <img width="1920" height="1077" alt="image" src="https://github.com/user-attachments/assets/a966c5ca-ef0a-4ecf-882b-e7ef55dde74e" /> | <img width="1918" height="1078" alt="image" src="https://github.com/user-attachments/assets/745aafcd-246e-4433-a81f-37a88ac5c1ee" /> |





</div>

<div align="center">
    <h2>• warning •</h2>
</div>

These dots are based on **illogical-impulse**. You can access original **illogical-impulse** dots from [here](https://github.com/end-4/dots-hyprland)

This dots contains my tweaks to original illogical-impulse dots. It's mostly up to date with original dots and my daily driver. However there may be bugs and stability issues. You can join this [ii-vynx channel](https://discord.com/channels/1393080422245863506/1457739857240653961) in end-4's official discord server to report the bugs and chat about this repository. Use [Github Issues](https://github.com/vaguesyntax/ii-vynx/issues) for real issue though.

**P.S.** Before saying _"These dots are bloated"_, keep in mind that there’s a toggle for everything.

<div align="center">
    <h2>• installation •</h2>
</div>

1. **Install the [original dots](https://github.com/end-4/dots-hyprland)**

2. Clone this repository like this:

```
git clone https://github.com/vaguesyntax/ii-vynx.git --recurse-submodules
```

3. Backup your existing configuration files (recommended):

```
mv ~/.config/quickshell/ii ~/.config/quickshell/ii.backup
```

Tip: You can see all flags with `--help`:
```
cp -r ii-vynx/dots/.config/quickshell/ii ~/.config/quickshell/
```
5. Restart the shell with `SUPER+CTRL+R`, done!

If something breaks, you can always restore your backup (original dots):

```
mv ~/.config/quickshell/ii.backup ~/.config/quickshell/ii
```

<div align="center">
    <h2>• updating •</h2>
</div>

Run the setup script:
  
```bash
./setup-ii-vynx.sh
```

Run the cli (if it's installed):
  
```bash
vynx update
```

Use the update button:
  
<img width="354" height="78" alt="image" src="https://github.com/user-attachments/assets/77d9d962-00b3-48a4-b9d5-1d3d0c053e86" />


<div align="center">
    <h2>• documentation •</h2>
</div>

Please refer to [this repository's wiki](https://github.com/vaguesyntax/ii-vynx/wiki) for detailed component descriptions and further information.

<div align="center">
    <h2>• PRs •</h2>
</div>

- PR: https://github.com/end-4/dots-hyprland/pull/2539 -> Video wallpaper fixes | Branch: [video-wallpaper-fixes](https://github.com/vaguesyntax/dots-hyprland/tree/video-wallpaper-fixes)
- PR: https://github.com/end-4/dots-hyprland/pull/2515 -> Config option for overview to show only on focused monitor | Branch  [overview-on-focused-monitor](https://github.com/vaguesyntax/dots-hyprland/tree/overview-on-focused-monitor)

<div align="center">
    <h2>• other available features •</h2>
</div>

- Bar rework  **_// security and timer indicators, custom ordering and more.._**
- Workspaces widget rework **_// ability to show multiple windows in one workspace_**
- Background media widget
- Settings color scheme previews **_// custom color schemes_**
- Cookie clock improvements
- File search functionality in launcher
- Extended calendar functionality from this PR: https://github.com/end-4/dots-hyprland/pull/1887 _**// in sync with google calendar, tweaked**_
- Current overview changes for [hyprscrolling plugin](https://github.com/vaguesyntax/hyprscrolling) 
- New overview style for my hyprscrolling plugin:
<img width="960" height="540" alt="image" src="https://github.com/user-attachments/assets/40579084-3cc5-4330-b598-9be6015d7a3a" />

<div align="center">
    <h2>• hyprscrolling implementation •</h2>
</div>


A [Niri](https://github.com/YaLTeR/niri) like scrollable tiling layout.
You have to use my hyprscrolling plugin in order to make shell communicate with plugin.

- Realtime windows position and size communication with plugin
- You can move windows in **different** workspaces
- You can swap the places of windows **in the same row** 

Follow the documentation on [my hyprscrolling plugin](https://github.com/vaguesyntax/hyprscrolling) to install and configure it.

<div align="center">
    <h2>• credits •</h2>
</div>

**[end-4](https://github.com/end-4):** Creator of illogical-impulse, alien

**[ii](https://github.com/end-4/dots-hyprland):** A perfect hyprland dots in material-3 style

**[Quickshell](https://quickshell.org/):** Qt-Quick based widget system for hyprland

**[Hyprland](https://hypr.land/):** Loves-to-crash wayland compositor


**Since you scrolled all the way down here, can I get your star? ⭐**






# Drawer System Documentation

## Overview

The drawer system in this QuickShell configuration provides a modular overlay system for displaying various UI components like on-screen displays (OSD), search/overview interfaces, and other interactive elements. The system is designed to work across multiple screens and integrates seamlessly with the bar component.

## Architecture

### Core Components

#### 1. Main Drawer System (`/modules/ii/drawers/`)

**Drawers.qml** - The main drawer container that creates overlay windows for each screen:
- Creates `PanelWindow` instances with overlay layer
- Handles fullscreen detection and visibility management
- Implements focus grabbing for overview mode
- Provides masking for click-through areas around panels
- Manages background and panel positioning

**Panels.qml** - Panel container that manages different drawer types:
- Imports and positions OSD (On-Screen Display) wrapper
- Imports and positions Search/Overview wrapper
- Handles visibility states for each panel type
- Centers panels horizontally at the top of the screen

**Backgrounds.qml** - Background rendering for drawer overlays:
- Provides visual background behind panels
- Handles blur and visual effects
- Integrates with appearance configuration

#### 2. Bar-Integrated Drawers (`/modules/ii/bar/drawers/`)

**Panels.qml** - Bar-specific panel implementation:
- Similar structure to main panels but integrated into bar context
- Used when drawers appear within bar space
- Shares the same OSD and Search/overview components

**Backgrounds.qml** - Bar-specific background implementation:
- Tailored for bar integration context
- Maintains visual consistency with main drawer backgrounds

#### 3. On-Screen Display Drawer (`/modules/ii/onScreenDisplay/drawer/`)

**Wrapper.qml** - OSD container and animation controller:
- Manages show/hide animations with configurable curves
- Handles indicator switching (volume, brightness, player volume)
- Listens to system events (brightness changes, audio changes, media player events)
- Loads appropriate indicator components dynamically

**Background.qml** - OSD-specific background styling:
- Provides visual backdrop for OSD elements
- Integrates with global appearance settings

#### 4. Overview/Search Drawer (`/modules/ii/overview/drawer/`)

**Wrapper.qml** - Search/overview container:
- Manages show/hide animations
- Handles search state management and cleanup
- Provides screen context to content components
- Auto-cancels search when hidden

**Content.qml** - Main search interface implementation:
- Contains search UI logic and components
- Manages search results and interactions
- Handles keyboard navigation

**Background.qml** - Overview-specific background styling:
- Provides visual backdrop for search interface

## Integration Points

### Bar Integration (`/modules/ii/bar/Bar.qml`)

The bar system integrates drawers through several key mechanisms:

1. **Import Statement**: `import qs.modules.ii.bar.drawers`

2. **Drawer Loader** (lines 254-276):
   ```qml
   Loader {
       anchors.fill: parent
       active: (DrawerVisibilityConfig.barOsdVisible || DrawerVisibilityConfig.barSearchOverviewVisible) && !barLoader.fullscreen
       sourceComponent: Item {
           // Backgrounds and Panels components
       }
   }
   ```

3. **Visibility Conditions**:
   - `DrawerVisibilityConfig.barOsdVisible` - Controls OSD visibility in bar context
   - `DrawerVisibilityConfig.barSearchOverviewVisible` - Controls search visibility in bar context
   - `!barLoader.fullscreen` - Prevents drawer display when fullscreen window is active

### Visibility Configuration

The system uses `DrawerVisibilityConfig` to manage visibility states:
- `barOsdVisible` - OSD visibility in bar context
- `barSearchOverviewVisible` - Search visibility in bar context  
- `fullScreenOsdVisible` - OSD visibility in fullscreen context
- `fullScreenSearchOverviewVisible` - Search visibility in fullscreen context

## Implementation Guide

### Adding New Drawer Types

1. **Create Drawer Component**:
   - Add new drawer type in appropriate directory (`/drawers/`, `/bar/drawers/`, or new subdirectory)
   - Follow existing wrapper pattern with show/hide animations

2. **Update Panels.qml**:
   - Import new drawer component
   - Add wrapper instance with proper positioning
   - Connect to visibility configuration

3. **Configure Visibility**:
   - Add visibility flags to `DrawerVisibilityConfig`
   - Update activation conditions in relevant containers

### Customizing Animations

Animation settings are controlled through:
- `Config.options.appearance.panelAnimation.enterDuration`
- `Config.options.appearance.panelAnimation.exitDuration`
- `Appearance.animationCurves.standard` (bezier curve)

### Adding New Indicators (OSD)

To add new OSD indicators:

1. **Create Indicator Component** in `/onScreenDisplay/indicators/`
2. **Update Wrapper.qml` indicators array:
   ```qml
   property var indicators: [
       // existing indicators...
       {
           id: "newIndicator",
           sourceUrl: "../indicators/NewIndicator.qml"
       }
   ]
   ```
3. **Add Event Listeners** for triggering the indicator

### Screen Management and Layer Strategy

The drawer system uses different Wayland layers depending on context:

- **Main Drawers**: Uses `WlrLayer.Overlay` for fullscreen overlay behavior
- **Bar Drawers**: Uses `WlrLayer.Top` when integrated with bar

**Why Bar Integration Matters**: Drawers were added to the bar specifically to ensure visual consistency. When panels are attached to the bar, they inherit the same blur background as the bar itself. Without this integration (using the bar drawer loader), panels would have different background rendering when blur/transparency is enabled in the configuration, creating visual inconsistency.

The drawer system automatically handles:
- Multi-screen setups through `Variants` components
- Screen-specific visibility via `Visibilities.getForScreen()`
- Fullscreen detection and exclusion zones
- Proper layering based on context (Overlay vs Top)

## Configuration Dependencies

The drawer system depends on:
- `Config.options.appearance.panelAnimation` - Animation settings
- `Config.options.bar` - Bar integration settings
- `Appearance.sizes` - Dimension constants
- `Appearance.colors` - Color scheme
- `GlobalStates` - Global state management
- `DrawerVisibilityConfig` - Visibility control

## Usage Examples

### Triggering OSD Display
```qml
// Volume change automatically triggers volume indicator
Audio.sink.audio.volumeChanged() -> currentIndicator = "volume"
```

### Showing Search Overview
```qml
// Set visibility through global state
DrawerVisibilityConfig.barSearchOverviewVisible = true
```

### Custom Drawer Implementation
```qml
// Follow existing wrapper pattern
Item {
    property bool shown: false
    
    states: [
        State { name: "open"; when: shown },
        State { name: "closed"; when: !shown }
    ]
    
    transitions: Transition {
        // Animation configuration
    }
}
```

## File Structure Summary

```
/modules/ii/drawers/
├── Drawers.qml          # Main drawer container
├── Panels.qml           # Panel management
└── Backgrounds.qml      # Background rendering

/modules/ii/bar/drawers/
├── Panels.qml           # Bar-specific panels
└── Backgrounds.qml      # Bar-specific backgrounds

/modules/ii/onScreenDisplay/drawer/
├── Wrapper.qml          # OSD container and animations
└── Background.qml       # OSD background

/modules/ii/overview/drawer/
├── Wrapper.qml          # Search container
├── Content.qml          # Search interface
└── Background.qml       # Search background
```

This modular architecture allows for easy extension and customization while maintaining consistency across different drawer types and contexts.
