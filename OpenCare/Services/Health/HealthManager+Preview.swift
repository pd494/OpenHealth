#if DEBUG
extension HealthManager {
    static var preview: HealthManager {
        let manager = HealthManager()
        manager.loadDemo()
        return manager
    }
}
#endif
