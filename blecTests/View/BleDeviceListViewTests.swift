import ViewInspector
import XCTest

@testable import blec

extension BleDeviceListView: Inspectable {}

final class BleDeviceListViewTests: XCTestCase {
  /**
   初期表示
   - Throws:
   */
  func testInitialView() throws {
    var subject = BleDeviceListView()
    let exp = subject.on(\.didAppear) { view in
      try XCTContext.runActivity(named: "スキャンボタンのテキスト") { _ in
        XCTAssertEqual(
          try view
            .navigationView()
            .zStack(0)
            .vStack(1)
            .button(0).labelView().text().string(), "スキャン開始")
      }
    }
    ViewHosting.host(
      view: subject.environmentObject(CoreBluetoothViewModel()))
    wait(for: [exp], timeout: 0.2)
  }
}
