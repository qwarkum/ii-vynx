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
