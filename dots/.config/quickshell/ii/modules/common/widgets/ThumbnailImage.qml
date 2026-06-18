import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

/**
 * Thumbnail image. It currently generates to the right place at the right size, but does not handle metadata/maintenance on modification.
 * See Freedesktop's spec: https://specifications.freedesktop.org/thumbnail-spec/thumbnail-spec-latest.html
 */
StyledImage {
    id: root

    property bool generateThumbnail: true
    required property string sourcePath
    property int thumbnailMaxSize: 512
    property string thumbnailSizeName: Images.thumbnailSizeNameForDimensions(thumbnailMaxSize, thumbnailMaxSize)
    property string thumbnailPath: {
        if (sourcePath.length == 0) return;
        const resolvedUrlWithoutFileProtocol = FileUtils.trimFileProtocol(`${Qt.resolvedUrl(sourcePath)}`);
        const encodedUrlWithoutFileProtocol = resolvedUrlWithoutFileProtocol.split("/").map(part => encodeURIComponent(part)).join("/");
        const md5Hash = Qt.md5(`file://${encodedUrlWithoutFileProtocol}`);
        return `${Directories.genericCache}/thumbnails/${thumbnailSizeName}/${md5Hash}.png`;
    }
    source: thumbnailPath
    sourceSize: Qt.size(thumbnailMaxSize, thumbnailMaxSize)

    asynchronous: true
    smooth: true
    mipmap: false

    opacity: status === Image.Ready ? 1 : 0
    Behavior on opacity { enabled: false }

    onSourcePathChanged: {
        if (!root.generateThumbnail) return;
        thumbnailGeneration.running = false;
        thumbnailGeneration.running = true;
    }

    Component.onCompleted: {
        if (root.generateThumbnail && status !== Image.Ready) {
            thumbnailGeneration.running = true;
        }
    }

    Process {
        id: thumbnailGeneration
        command: {
            const maxSize = root.thumbnailMaxSize;
            const thumbFile = FileUtils.trimFileProtocol(root.thumbnailPath)
            return ["bash", "-c",
                `[ -f '${thumbFile}' ] && exit 0 || { mkdir -p "$(dirname '${thumbFile}')" && magick '${root.sourcePath}' -resize ${maxSize}x${maxSize} '${thumbFile}' && exit 1; }`
            ]
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 1) { // Force reload if thumbnail had to be generated
                root.source = "";
                root.source = root.thumbnailPath; // Force reload
            }
        }
    }
}
