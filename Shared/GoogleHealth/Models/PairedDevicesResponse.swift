import Foundation

struct PairedDevicesResponse: Decodable {
    struct Device: Decodable {
        let deviceType: String?
        let deviceVersion: String?
        let lastSyncTime: Date?
    }

    let pairedDevices: [Device]?

    /// Only a tracker counts; other paired devices can carry "Air" in their name too.
    var air: PairedAir? {
        pairedDevices?.lazy.compactMap { device -> PairedAir? in
            guard device.deviceType == "TRACKER",
                  let version = device.deviceVersion,
                  version.localizedCaseInsensitiveContains("Air") else { return nil }
            return PairedAir(name: version, lastSync: device.lastSyncTime)
        }.first
    }
}
