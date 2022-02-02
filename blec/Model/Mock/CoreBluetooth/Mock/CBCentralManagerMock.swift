//
// Created by mix on 2022/01/28.
//

import CoreBluetooth
import Foundation

class CBCentralManagerMock: Mock, CBCentralManagerProtocol {
  var delegate: CBCentralManagerDelegate?
  var isScanning: Bool = false
  var state: CBManagerState = .poweredOff
  let name = "BLE MOCK"

  required public init(
    delegate: CBCentralManagerDelegate?,
    queue: DispatchQueue?,
    options: [String: Any]?
  ) {
    self.delegate = delegate
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.state = .poweredOn
      if let delegate = self.delegate as? CBCentralManagerProtocolDelegate {
        delegate.didUpdate(self)
      }
    }
  }

  func retrievePeripherals(_ identifiers: [UUID]) -> [CBPeripheralProtocol] {
    log(#function)
    return identifiers.map {
      CBPeripheralMock(
        identifier: $0,
        name: name
      )
    }
  }

  func scanForPeripherals(
    withServices serviceUUIDs: [CBUUID]?, options: [String: Any]?
  ) {
    log(#function)
    isScanning = true

    if let delegate = delegate as? CoreBluetoothViewModel {
      let discoveredPeripheral = CBPeripheralMock(
        identifier: UUID(), name: name)

      delegate.didDiscover(
        self,
        peripheral: discoveredPeripheral,
        advertisementData: [:],
        rssi: -30)
    }
  }

  func stopScan() {
    log(#function)
    isScanning = false
  }

  func cancelPeripheralConnection(_ peripheral: CBPeripheralProtocol) {
    log(#function)
    if let delegate = delegate as? CBCentralManagerProtocolDelegate {
      delegate.didDisconnect(self, peripheral: peripheral, error: nil)
    }
  }

  func connect(_ peripheral: CBPeripheralProtocol, options: [String: Any]?) {
    log(#function)
    if let delegate = delegate as? CBCentralManagerProtocolDelegate {
      delegate.didConnect(self, peripheral: peripheral)
    }
  }
}
