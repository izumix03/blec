//
// Created by mix on 2022/01/27.
//

import CoreBluetooth
import Foundation
import SwiftUI

extension CoreBluetoothViewModel: CBCentralManagerDelegate, CBPeripheralDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    didUpdate(central)
  }

  func centralManager(
    _ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any], rssi RSSI: NSNumber
  ) {
    didDiscover(
      central, peripheral: peripheral, advertisementData: advertisementData,
      rssi: RSSI)
  }
}
