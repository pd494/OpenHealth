import XCTest
@testable import OpenHealth

final class DashboardLayoutTests: XCTestCase {
    private var layout = DashboardLayout.default

    private func order(_ items: [DashboardItem]) -> [MetricID] { items.map(\.metric) }

    func testMoveBeforeTargetReordersIndividually() {
        layout.move(.weight, before: .distance)
        XCTAssertEqual(order(layout.tiles).first, .weight)
        XCTAssertEqual(order(layout.tiles)[1], .distance)
    }

    func testMoveToNilGoesAfterLastTile() {
        layout.move(.distance, before: nil)
        XCTAssertEqual(order(layout.tiles).last, .distance)
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

    func testStyleAppliesToMetricsWithAndWithoutGoals() {
        layout.setStyle(.hydration, .ring)
        XCTAssertTrue(order(layout.rings).contains(.hydration))
        layout.setStyle(.weight, .ring)
        XCTAssertTrue(order(layout.rings).contains(.weight))
    }

    func testCaloriePreferenceChoosesDisplayedID() {
        XCTAssertTrue(order(layout.pills).contains(.activeEnergy))
        layout.calories = .total
        XCTAssertTrue(order(layout.pills).contains(.totalEnergy))
        XCTAssertFalse(order(layout.pills).contains(.activeEnergy))
        layout.setVisible(.totalEnergy, false)
        XCTAssertTrue(order(layout.hidden).contains(.totalEnergy))
    }

    func testEncodingRoundTripKeepsOrderVisibilityAndStyle() throws {
        layout.move(.weight, before: .hydration)
        layout.setVisible(.hrv, false)
        layout.setStyle(.hydration, .ring)
        layout.ringsMode = .beside
        layout.ringDetailsCollapsed = true
        layout.tileLayout = .list
        layout.calories = .total
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

extension DashboardLayoutTests {
    func testAnyMetricCanBePinnedOrShownAsRing() {
        var layout = DashboardLayout.default
        layout.setStyle(.heartRate, .pill)
        XCTAssertTrue(layout.pills.contains { $0.metric == .heartRate })
        layout.setStyle(.heartRate, .ring)
        XCTAssertTrue(layout.rings.contains { $0.metric == .heartRate })
    }

    @MainActor func testShiftPillReordersWithinGoalsCard() {
        let store = DashboardLayoutStore(layout: .default)
        let first = store.layout.pills.map(\.metric)
        store.shiftPill(first[0], by: 1)
        XCTAssertEqual(store.layout.pills.map(\.metric), [first[1], first[0]])
    }
}
