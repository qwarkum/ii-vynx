import QtQuick
import Qt5Compat.GraphicalEffects
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Item {
    id: root

    property var model: []
    property var imageSources: []
    property Component delegate: null
    property string carouselType: "multibrowse"
    property string alignment: "start"
    property real itemWidth: 200
    property real itemSpacing: 8
    property real topPadding: 8
    property real bottomPadding: 8
    property real leftPadding: 16
    property real rightPadding: 16
    property bool snapEnabled: true

    property int currentIndex: 0
    property list<real> sizeRatios: [6, 3, 1]
    readonly property real itemHeight: height - topPadding - bottomPadding

    signal itemClicked(int index, var modelData)

    clip: true

    readonly property real _totalRatio: sizeRatios[0] + sizeRatios[1] + sizeRatios[2]
    readonly property real _itemAreaWidth: Math.max(0, width - leftPadding - rightPadding - 2 * itemSpacing)
    readonly property real _unitWidth: _itemAreaWidth / _totalRatio

    readonly property real _largeW: Math.max(40, _unitWidth * sizeRatios[0])
    readonly property real _mediumW: Math.max(30, _unitWidth * sizeRatios[1])
    readonly property real _smallW: Math.max(20, _unitWidth * sizeRatios[2])
    readonly property real _stepSize: _largeW + itemSpacing

    readonly property var _slotX: [
        root.leftPadding - root.itemSpacing,
        root.leftPadding,
        root.leftPadding + _largeW + itemSpacing,
        root.leftPadding + _largeW + itemSpacing + _mediumW + itemSpacing,
        root.leftPadding + _largeW + itemSpacing + _mediumW + itemSpacing + _smallW + itemSpacing
    ]
    readonly property var _slotWidth: [0, _largeW, _mediumW, _smallW, 0]

    function snapToIndex(index) {
        if (index < 0 || index >= repeater.count) return
        const target = index * _stepSize
        const maxX = Math.max(0, (repeater.count - 1) * _stepSize)
        snapAnim.from = flickable.contentX
        snapAnim.to = Math.min(target, maxX)
        snapAnim.start()
    }

    StyledFlickable {
        id: flickable
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: root.topPadding
            bottomMargin: root.bottomPadding
        }
        height: root.itemHeight
        contentHeight: height
        contentWidth: Math.max(width, (repeater.count - 1) * root._stepSize + width)
        clip: false
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        interactive: repeater.count > 1

        Repeater {
            id: repeater
            model: root.model

            delegate: Item {
                id: itemContainer
                required property var modelData
                required property int index

                readonly property real slotDist: index - (flickable.contentX / root._stepSize)
                readonly property real arrayIdx: slotDist + 1
                readonly property int slotFloor: Math.max(0, Math.min(Math.floor(arrayIdx), 4))
                readonly property real slotFrac: arrayIdx - slotFloor
                readonly property int slotCeil: Math.min(slotFloor + 1, 4)

                readonly property real targetWidth: Math.max(0, root._slotWidth[slotFloor] + (root._slotWidth[slotCeil] - root._slotWidth[slotFloor]) * slotFrac)
                readonly property real targetViewportX: root._slotX[slotFloor] + (root._slotX[slotCeil] - root._slotX[slotFloor]) * slotFrac
                readonly property real cornerRadius: Appearance.rounding.large
                readonly property bool isFocal: root.currentIndex === index

                width: targetWidth
                height: flickable.height
                x: flickable.contentX + targetViewportX
                visible: width > 0.5

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: itemContainer.width
                        height: itemContainer.height
                        radius: itemContainer.cornerRadius
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: Appearance.colors.colSurfaceContainerHighest
                    radius: itemContainer.cornerRadius

                    Item {
                        id: delegateContainer
                        anchors.fill: parent
                    }
                }

                Rectangle {
                    id: stateOverlay
                    anchors.fill: parent
                    radius: itemContainer.cornerRadius
                    color: "transparent"

                    property color hoverColor: ColorUtils.transparentize(Appearance.colors.colOnSurface, 0.95)
                    property color pressedColor: ColorUtils.transparentize(Appearance.colors.colOnSurface, 0.8)

                    Behavior on color {
                        ColorAnimation {
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.itemClicked(itemContainer.index, itemContainer.modelData)
                    hoverEnabled: true
                    onContainsMouseChanged: {
                        stateOverlay.color = containsMouse ? stateOverlay.hoverColor : "transparent"
                    }
                    onPressedChanged: {
                        stateOverlay.color = pressed ? stateOverlay.pressedColor : (containsMouse ? stateOverlay.hoverColor : "transparent")
                    }
                }

                Component.onCompleted: {
                    if (root.delegate) {
                        var obj = root.delegate.createObject(delegateContainer, {
                            modelData: itemContainer.modelData,
                            index: itemContainer.index,
                            width: itemContainer.width,
                            height: itemContainer.height
                        })
                        if (obj) {
                            obj.width = Qt.binding(function() { return itemContainer.width })
                            obj.height = Qt.binding(function() { return itemContainer.height })
                        }
                    }
                }
            }
        }
    }

    NumberAnimation {
        id: snapAnim
        target: flickable
        property: "contentX"
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: [0.05, 0.7, 0.1, 1, 1, 1]
        onFinished: {
            updateCurrentIndex()
        }
    }

    function updateCurrentIndex() {
        if (repeater.count === 0) {
            currentIndex = -1
            return
        }
        const rawIndex = flickable.contentX / _stepSize
        const clamped = Math.max(0, Math.min(repeater.count - 1, Math.round(rawIndex)))
        if (clamped !== currentIndex) {
            currentIndex = clamped
            currentIndexChanged()
        }
    }

    onWidthChanged: updateCurrentIndex()

    Connections {
        target: flickable
        function onContentXChanged() {
            if (!snapAnim.running) {
                updateCurrentIndex()
            }
        }
        function onMovementEnded() {
            if (root.snapEnabled && !snapAnim.running) {
                snapToIndex(root.currentIndex)
            }
        }
    }
}
