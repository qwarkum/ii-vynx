import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool showDate: Config.options.bar.verbose
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 8
    implicitHeight: Appearance.sizes.barHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4

        StyledText {
            visible: root.showDate
            color: Appearance.colors.colOnLayer1
            text: DateTime.longDate
        }

        StyledText {
            visible: root.showDate
            color: Appearance.colors.colOnLayer1
            text: "•"
        }

        Item {
            implicitHeight: parent.height
            implicitWidth: threshold.width
            Layout.alignment: Qt.AlignVCenter
            
            StyledText {
                id: timeText
                color: Appearance.colors.colOnLayer1
                text: DateTime.timeSeconds
            }
        }
        
        Text {
            id: threshold
            visible: false
            text: Config.options.time.secondPrecision ? "00:00:00" : "00:00"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !Config.options.bar.tooltips.clickToShow

        ClockWidgetPopup {
            hoverTarget: mouseArea
        }
    }
}
