//
// Created by mix on 2022/02/02.
//

import XCTest

@testable import blec

let peripheralUUID = UUID()
let peripheralMock = CBPeripheralMock(
  identifier: peripheralUUID,
  name: "sample"
)

class PeripheralTests: XCTestCase {
  let peripheral = Peripheral(
    _peripheral: peripheralMock,
    _name: peripheralMock.name!,
    _advData: [:],
    _rssi: -30,
    _discoverCount: 0
  )

  func testEquals() {
    XCTContext.runActivity(named: "uuid が違う場合") { _ in
      XCTAssertEqual(peripheral.equals(uuid: UUID()), false)
    }

    XCTContext.runActivity(named: "uuid が同じ場合") { _ in
      XCTAssertEqual(peripheral.equals(uuid: peripheralUUID), true)
    }
  }
}
