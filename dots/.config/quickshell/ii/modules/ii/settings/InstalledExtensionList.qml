import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import "."

ColumnLayout {
    id: root

    StyledText {
        Layout.fillWidth: true
        Layout.topMargin: 20
        visible: Object.keys(ExtensionManager.installedExtensions).length > 0
        text: Translation.tr("Installed")
        font.pixelSize: Appearance.font.pixelSize.normal
        font.weight: Font.Medium
        color: Appearance.colors.colOnLayer0
    }

    Repeater {
        model: {
            let list = []
            for (let id in ExtensionManager.installedExtensions) {
                list.push(ExtensionManager.installedExtensions[id])
            }
            return list
        }
        delegate: InstalledExtensionCard {}
    }
}
