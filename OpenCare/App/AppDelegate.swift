import BackgroundTasks
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    private static let refreshID = "com.prasanthdendukuri.opencare.refresh"
    private static let refreshInterval: TimeInterval = 15 * 60

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.refreshID, using: nil) { [weak self] task in
            self?.scheduleRefresh()
            let work = Task { @MainActor in
                await AppRefresh.run()
                task.setTaskCompleted(success: !Task.isCancelled)
            }
            task.expirationHandler = { work.cancel() }
        }
        HealthManager.shared.startObservers()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleRefresh()
    }

    private func scheduleRefresh() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.refreshID)
        let request = BGAppRefreshTaskRequest(identifier: Self.refreshID)
        request.earliestBeginDate = .now.addingTimeInterval(Self.refreshInterval)
        try? BGTaskScheduler.shared.submit(request)
    }
}
