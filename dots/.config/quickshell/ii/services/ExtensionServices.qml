pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    id: root

    property var loaded: ({})

    function ensure(extId, serviceId, qmlPath) {
        let key = extId + "." + serviceId
        if (root.loaded[key]) return root.loaded[key]

        let comp = Qt.createComponent(qmlPath)
        if (comp.status === Component.Error) {
            console.warn("ExtensionServices: failed to create component for", key, ":", comp.errorString())
            return null
        }
        if (comp.status === Component.Ready) {
            let instance = comp.createObject(null)
            if (instance) {
                let updated = Object.assign({}, root.loaded)
                updated[key] = instance
                root.loaded = updated
            }
            return instance
        }
        return null
    }

    function unload(extId, serviceId) {
        let key = extId + "." + serviceId
        if (root.loaded[key]) {
            root.loaded[key].destroy()
        }
        let updated = Object.assign({}, root.loaded)
        delete updated[key]
        root.loaded = updated
    }

    function unloadExtension(extId) {
        let prefix = extId + "."
        let updated = Object.assign({}, root.loaded)
        for (let key in root.loaded) {
            if (key.startsWith(prefix)) {
                if (updated[key]) updated[key].destroy()
                delete updated[key]
            }
        }
        root.loaded = updated
    }

    function get(extId, serviceId) {
        return root.loaded[extId + "." + serviceId] || null
    }
}
