import XCTest
@testable import OpenCare

final class DashboardLayoutTests: XCTestCase {
    private var layout = DashboardLayout.default

    private func order(_ items: [DashboardItem]) -> [MetricID] { items.map(\.metric) }

    func testMoveBeforeTargetReordersIndividually() {
        layout.move(.weight, before: .hydration)
        XCTAssertEqual(order(layout.tiles).first, .weight)
        XCTAssertEqual(order(layout.tiles)[1], .hydration)
    }

    func testMoveToNilGoesAfterLastTile() {
        layout.move(.hydration, before: nil)
        XCTAssertEqual(order(layout.tiles).last, .hydration)
    }

    func testMoveBeforeItselfIsNoOp() {
        layout.move(.hrv, before: .hrv)
        XCTAssertEqual(layout, .default)
    }

    func testVisibilityMovesItemsToHiddenTray() {
        layout.setVisible(.weight, false)
        XCTAssertFalse(order(layout.tiles).contains(.weight))
        XCTAssertTrue(order(layout.hidden).contains(.weight))
        layout.setVisible(.fat, true)
        XCTAssertTrue(order(layout.tiles).contains(.fat))
    }

    func testStyleOnlyAppliesToGoalMetrics() {
        layout.setStyle(.hydration, .ring)
        XCTAssertTrue(order(layout.rings).contains(.hydration))
        layout.setStyle(.weight, .ring)
        XCTAssertFalse(order(layout.rings).contains(.weight))
    }

    func testCaloriePreferenceChoosesDisplayedID() {
        XCTAssertTrue(order(layout.tiles).contains(.activeEnergy))
        layout.calories = .total
        XCTAssertTrue(order(layout.tiles).contains(.totalEnergy))
        XCTAssertFalse(order(layout.tiles).contains(.activeEnergy))
        layout.setVisible(.totalEnergy, false)
        XCTAssertTrue(order(layout.hidden).contains(.totalEnergy))
    }

    func testEncodingRoundTripKeepsOrderVisibilityAndStyle() throws {
        layout.move(.weight, before: .hydration)
        layout.setVisible(.hrv, false)
        layout.setStyle(.hydration, .ring)
        layout.ringsMode = .beside
        layout.ringDetailsCollapsed = true
        let decoded = try JSONDecoder().decode(DashboardLayout.self, from: JSONEncoder().encode(layout))
        XCTAssertEqual(decoded, layout)
    }

    func testDecodingDropsUnknownMetrics() throws {
        let json = """
        {"items":[{"metric":"steps","isVisible":true,"style":"ring"},\
        {"metric":"teleportation","isVisible":true,"style":"tile"}]}
        """
        let decoded = try JSONDecoder().decode(DashboardLayout.self, from: Data(json.utf8))
        XCTAssertEqual(order(decoded.items), [.steps])
    }

    func testReconcileAddsNewMetricsHiddenAndKeepsExistingOrder() {
        let old = DashboardLayout(items: [
            .init(metric: .weight, isVisible: true, style: .tile),
            .init(metric: .steps, isVisible: true, style: .ring)
        ])
        let result = old.reconciled()
        XCTAssertEqual(order(result.items).prefix(2), [.weight, .steps])
        XCTAssertEqual(result.items.count, MetricID.allCases.count - 1)
        XCTAssertTrue(result.hidden.count == result.items.count - 2)
    }

    @MainActor
    func testStorePersistsAcrossInstances() {
        Defaults[.dashboardLayout] = nil
        let store = DashboardLayoutStore()
        store.moveTile(.weight, to: 0)
        store.setRingsMode(.expanded)
        let reloaded = DashboardLayoutStore()
        XCTAssertEqual(reloaded.layout.tiles.first?.metric, .weight)
        XCTAssertEqual(reloaded.layout.ringsMode, .expanded)
        Defaults[.dashboardLayout] = nil
    }

    @MainActor
    func testShiftRingSwapsNeighbours() {
        Defaults[.dashboardLayout] = nil
        let store = DashboardLayoutStore()
        store.shiftRing(.steps, by: 1)
        XCTAssertEqual(order(store.layout.rings), [.recovery, .steps, .sleep])
        store.shiftRing(.sleep, by: -1)
        XCTAssertEqual(order(store.layout.rings), [.recovery, .sleep, .steps])
        Defaults[.dashboardLayout] = nil
    }
}
