//
// Created by mix on 2022/01/28.
//

import CoreBluetooth
import Foundation

extension CBPeripheral: CBPeripheralProtocol {}

/// Central Manager の protocol
protocol CBCentralManagerProtocol {
  var delegate: CBCentralManagerDelegate? { get set }
  var isScanning: Bool { get }
  var state: CBManagerState { get }

  init(
    delegate: CBCentralManagerDelegate?, queue: DispatchQueue?,
    options: [String: Any]?)
  func retrievePeripherals(_ identifiers: [UUID]) -> [CBPeripheralProtocol]
  func scanForPeripherals(
    withServices serviceUUIDs: [CBUUID]?, options: [String: Any]?)
  func stopScan()
  func connect(_ peripheral: CBPeripheralProtocol, options: [String: Any]?)
  func cancelPeripheralConnection(_ peripheral: CBPeripheralProtocol)
}

/// CentralManager の挙動を Protocol にあわせて拡張
extension CBCentralManager: CBCentralManagerProtocol {
  func cancelPeripheralConnection(_ peripheral: CBPeripheralProtocol) {
    guard let peripheral = peripheral as? CBPeripheral else { return }
    cancelPeripheralConnection(peripheral)
  }

  func retrievePeripherals(_ identifiers: [UUID]) -> [CBPeripheralProtocol] {
    retrievePeripherals(withIdentifiers: identifiers)
  }

  func connect(_ peripheral: CBPeripheralProtocol, options: [String: Any]?) {
    guard let peripheral = peripheral as? CBPeripheral else { return }
    connect(peripheral, options: options)
  }
}

/// CentralManager を Protocol で利用するように拡張
/// CoreBluetoothViewModel の拡張で合致させる
protocol CBCentralManagerProtocolDelegate {
  func didUpdate(_ central: CBCentralManagerProtocol)
  func didDiscover(
    _ central: CBCentralManagerProtocol,
    peripheral: CBPeripheralProtocol,
    advertisementData: [String: Any],
    rssi RSSI: NSNumber)
  func didConnect(
    _ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol)
  func didDisconnect(
    _ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol,
    error: Error?)
}

/// Peripheral のプロトコル
protocol CBPeripheralProtocol {
  var delegate: CBPeripheralDelegate? { get set }

  var identifier: UUID { get }
  var name: String? { get }
  var rssi: NSNumber? { get }
  var services: [CBService]? { get }
  var canSendWriteWithoutResponse: Bool { get }
  var ancsAuthorized: Bool { get }

  func discoverServices(_ serviceUUIDs: [CBUUID]?)
  func discoverCharacteristics(
    _ characteristicUUIDs: [CBUUID]?, for service: CBService)
  func readValue(for characteristic: CBCharacteristic)
  func writeValue(
    _ data: Data, for characteristic: CBCharacteristic,
    type: CBCharacteristicWriteType)
  func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic)
  func discoverDescriptors(for characteristic: CBCharacteristic)
}

protocol CBPeripheralProtocolDelegate {
  func didDiscoverServices(_ peripheral: CBPeripheralProtocol, error: Error?)
  func didDiscoverCharacteristics(
    _ peripheral: CBPeripheralProtocol, service: CBService, error: Error?)
  func didUpdateValue(
    _ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic,
    error: Error?)
  func didWriteValue(
    _ peripheral: CBPeripheralProtocol, descriptor: CBDescriptor, error: Error?)
}
