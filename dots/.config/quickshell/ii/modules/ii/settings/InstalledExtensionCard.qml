import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    required property var modelData
    property var ext: modelData
    property var updateState: ExtensionManager.updateStates[ext.id] || {}
    property bool updateChecking: updateState.checking || false
    property bool updateAvailable: updateState.updateAvailable || false

    Layout.fillWidth: true
    Layout.preferredHeight: 80

    Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.normal
        color: Appearance.colors.colLayer1
        border.width: (ext.enabled || (ext.repoUrl && ext.repoUrl.includes("vaguesyntax"))) ? 1 : 0
        border.color: ext.enabled
            ? Appearance.colors.colPrimary
            : ((ext.repoUrl && ext.repoUrl.includes("vaguesyntax")) ? Appearance.colors.colSecondary : "transparent")

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 12

            MaterialSymbol {
                text: ext.enabled ? "check_circle" : "cancel"
                iconSize: 22
                color: ext.enabled ? Appearance.colors.colPrimary : Appearance.colors.colError
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    StyledText {
                        Layout.fillWidth: true
                        text: ext.name
                        font.pixelSize: Appearance.font.pixelSize.normal
                        font.weight: Font.Medium
                        color: Appearance.colors.colOnLayer0
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        visible: ext.repoUrl && ext.repoUrl.includes("vaguesyntax")
                        radius: 999
                        color: Appearance.colors.colSecondaryContainer
                        implicitWidth: childrenRect.width + 6
                        implicitHeight: childrenRect.height + 2
                        StyledText {
                            x: 3; y: 1
                            text: Translation.tr("Official")
                            font.pixelSize: Appearance.font.pixelSize.smallest
                            color: Appearance.colors.colOnSecondaryContainer
                        }
                    }
                    Rectangle {
                        visible: ExtensionManager.recommendedExtensions.includes(ext.id)
                        radius: 999
                        color: Appearance.colors.colTertiaryContainer
                        implicitWidth: childrenRect.width + 6
                        implicitHeight: childrenRect.height + 2
                        StyledText {
                            x: 3; y: 1
                            text: Translation.tr("Recommended")
                            font.pixelSize: Appearance.font.pixelSize.smallest
                            color: Appearance.colors.colOnTertiaryContainer
                        }
                    }
                }

                RowLayout {
                    spacing: 6
                    StyledText {
                        text: "v" + ext.version + " by " + ext.author
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colSubtext
                    }
                    StyledText {
                        visible: ext.repoUrl && updateChecking
                        text: Translation.tr("Checking update...")
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: Appearance.colors.colTertiary
                    }
                    StyledText {
                        visible: ext.repoUrl && updateAvailable && !updateChecking
                        text: Translation.tr("Update available!")
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: Appearance.colors.colPrimary
                    }
                    StyledText {
                        visible: ext.repoUrl && !updateChecking && !updateAvailable && !!updateState.localHash
                        text: Translation.tr("Up to date")
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: Appearance.colors.colSubtext
                    }
                    Item { Layout.fillWidth: true }
                }
            }

            StyledSwitch {
                checked: ext.enabled
                onClicked: ExtensionManager.toggleExtension(ext.id, !ext.enabled)
            }

            RippleButton {
                implicitWidth: 60
                implicitHeight: 28
                padding: 0
                buttonRadius: Appearance.rounding.full
                colBackground: updateAvailable ? Appearance.colors.colPrimaryContainer : Appearance.colors.colLayer3
                colBackgroundHover: updateAvailable ? Appearance.colors.colPrimaryContainerHover : Appearance.colors.colLayer3Hover
                visible: ext.repoUrl && ext.repoUrl.length > 0
                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: updateChecking ? "..." : (updateAvailable ? Translation.tr("Update") : Translation.tr("Check"))
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: updateAvailable ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colSubtext
                }
                onClicked: {
                    if (updateAvailable) {
                        ExtensionManager.updateExtension(ext.id)
                    } else {
                        ExtensionManager.checkUpdate(ext.id)
                    }
                }
            }

            RippleButton {
                implicitWidth: 60
                implicitHeight: 28
                padding: 0
                buttonRadius: Appearance.rounding.full
                colBackground: Appearance.colors.colError
                colBackgroundHover: Appearance.colors.colErrorHover
                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: Translation.tr("Remove")
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colOnError
                }
                onClicked: ExtensionManager.uninstallExtension(ext.id)
            }
        }
    }
}
