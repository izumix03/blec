//
// Created by mix on 2022/01/27.
//

import CoreBluetooth
import Foundation
import SwiftUI

extension CoreBluetoothViewModel: CBCentralManagerDelegate, CBPeripheralDelegate
{
  /**
   BLE ステータス変更時
   - Parameter central:
   */
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    didUpdate(central)
  }

  /**
   peripheral 発見
   - Parameters:
     - central:
     - peripheral:
     - advertisementData:
     - RSSI:
   */
  func centralManager(
    _ central: CBCentralManager,
    didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any],
    rssi RSSI: NSNumber
  ) {
    didDiscover(
      central, peripheral: peripheral, advertisementData: advertisementData,
      rssi: RSSI)
  }

  /**
   Service 発見
   - Parameters:
     - peripheral:
     - error:
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
  {
    didDiscoverServices(peripheral, error: error)
  }

  /**
   Characteristic 発見
   - Parameters:
     - peripheral:
     - service:
     - error:
   */
  func peripheral(
    _ peripheral: CBPeripheral,
    didDiscoverCharacteristicsFor service: CBService, error: Error?
  ) {
    didDiscoverCharacteristics(peripheral, service: service, error: error)
  }

  /**
   Peripheral value 変更
   - Parameters:
     - peripheral:
     - characteristic:
     - error:
   */
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    didUpdateValue(peripheral, characteristic: characteristic, error: error)
  }

  /**
   Peripheral 書き込み
   - Parameters:
     - peripheral:
     - descriptor:
     - error:
   */
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
    didWriteValue(peripheral, descriptor: descriptor, error: error)
  }

  /**
   ??
   - Parameters:
     - central:
     - dict:
   */
  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
  }

  /**
   peripheral 接続後
   - Parameters:
     - central:
     - peripheral:
   */
  func centralManager(
      _ central: CBCentralManager,
      didConnect peripheral: CBPeripheral
  ) {
    didConnect(central, peripheral: peripheral)
  }

  /**
   接続失敗
   - Parameters:
     - central:
     - peripheral:
     - error:
   */
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
  }

  /**
   接続遮断
   - Parameters:
     - central:
     - peripheral:
     - error:
   */
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    didDisconnect(central, peripheral: peripheral, error: error)
  }

  /**
   ？？
   - Parameters:
     - central:
     - event:
     - peripheral:
   */
  func centralManager(_ central: CBCentralManager,
                      connectionEventDidOccur event: CBConnectionEvent,
                      for peripheral: CBPeripheral) {
  }

  /**
   ??
   - Parameters:
     - central:
     - peripheral:
   */
  func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
  }
}
