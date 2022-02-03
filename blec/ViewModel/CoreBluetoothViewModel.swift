//
// Created by mix on 2022/01/27.
//

import CoreBluetooth
import Foundation
import SwiftUI

class CoreBluetoothViewModel: NSObject,
  ObservableObject, CBCentralManagerProtocolDelegate,
  CBPeripheralProtocolDelegate
{
  @Published var isBlePower: Bool = false
  @Published var isSearching: Bool = false
  @Published var isConnected: Bool = false

  @Published var foundPeripherals: [Peripheral] = []
  @Published var foundServices: [Service] = []
  @Published var foundCharacteristics: [Characteristic] = []

  private var centralManager: CBCentralManagerProtocol!
  private var connectedPeripheral: Peripheral?

  override required init() {
    super.init()
    #if targetEnvironment(simulator)
      centralManager = CBCentralManagerMock(
        delegate: self, queue: nil, options: nil)
    #else
      print("not simulator!!")
      centralManager = CBCentralManager(
        delegate: self,
        queue: nil,  // 画面のチラツキの方が気持ち悪い場合は DispatchQueue を行う
        options: [
          CBCentralManagerOptionShowPowerAlertKey: true
        ]
      )
    #endif
  }

  /**
   - 動作可能になった後に呼ばれる
   - Parameter central:
   */
  func didUpdate(_ central: CBCentralManagerProtocol) {
    isBlePower = central.state == .poweredOn
  }

  /**
   scan を開始する(手動)
   */
  func startScan() {
    let scanOption = [
      CBCentralManagerScanOptionAllowDuplicatesKey: true
    ]  // 同じデバイスの検知を通知しない
    centralManager.scanForPeripherals(
      withServices: nil, options: scanOption)
    print("# Start Scan")
    isSearching = true
  }

  /**
   既存接続をキャンセルして scan を停止する(手動)
   */
  func stopScan() {
    disconnectPeripheral()
    centralManager.stopScan()
    print("# Stop Scan")
    DispatchQueue.main.async {
      self.isSearching = false
    }
  }

  /**
   選択したペリフェラルに接続する(手動)
   - Parameter selectedPeripheral:
   */
  func connect(_ selectedPeripheral: Peripheral) {
    print("# Start Connect")
    connectedPeripheral = selectedPeripheral
    centralManager.connect(selectedPeripheral.peripheral, options: nil)
  }

  private func disconnectPeripheral() {
    guard let connectedPeripheral = connectedPeripheral else { return }
    centralManager.cancelPeripheralConnection(connectedPeripheral.peripheral)
  }

  func didDiscover(
    _ central: CBCentralManagerProtocol,
    peripheral: CBPeripheralProtocol,
    advertisementData: [String: Any],
    rssi RSSI: NSNumber
  ) {
    let pName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
    let name = pName != nil ? pName : peripheral.name

    let foundPeripheral = Peripheral(
      _peripheral: peripheral,
      _name: name ?? "NoName",
      _advData: advertisementData,
      _rssi: RSSI,
      _discoverCount: 0)

    if let index = foundPeripherals.firstIndex(where: {
      $0.equals(
        uuid: peripheral.identifier)
    }) {
      foundPeripherals[index].discoverCount += 1
    } else {
      foundPeripherals.append(foundPeripheral)
    }
  }

  /**
   接続した後の処理
   - Parameters:
     - central:
     - peripheral:
   */
  func didConnect(
    _ central: CBCentralManagerProtocol,
    peripheral: CBPeripheralProtocol
  ) {
    print("connect!!")
    guard let connectedPeripheral = connectedPeripheral
    else { return }
    isConnected = true
    connectedPeripheral.peripheral.delegate = self
    connectedPeripheral.peripheral.discoverServices(nil)
  }

  func didDisconnect(
    _ central: CBCentralManagerProtocol,
    peripheral: CBPeripheralProtocol,
    error: Error?
  ) {
    print("didDisconnect")
    withAnimation {
      isSearching = false
      isConnected = false

      foundPeripherals = []
      foundServices = []
      foundCharacteristics = []
    }
  }

  /**
   サービス発見時
   - Parameters:
     - peripheral:
     - error:
   */
  func didDiscoverServices(
    _ peripheral: CBPeripheralProtocol, error: Error?
  ) {
    peripheral.services?.forEach { service in
      let foundService = Service(_uuid: service.uuid, _service: service)
      foundServices.append(foundService)
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }

  /**
   characteristics 発見時
   - Parameters:
     - peripheral:
     - service:
     - error:
   */
  func didDiscoverCharacteristics(
    _ peripheral: CBPeripheralProtocol, service: CBService,
    error: Error?
  ) {
    service.characteristics?.forEach { characteristic in
      let setCharacteristic: Characteristic =
        Characteristic(
          _characteristic: characteristic,
          _description: "",
          _uuid: characteristic.uuid,
          _readValue: "",
          _service: characteristic.service)
      foundCharacteristics.append(setCharacteristic)
      peripheral.readValue(for: characteristic)
    }
  }

  /**
    characteristic の値が更新されたとき
   - Parameters:
     - peripheral:
     - characteristic:
     - error:
   */
  func didUpdateValue(
    _ peripheral: CBPeripheralProtocol,
    characteristic: CBCharacteristic,
    error: Error?
  ) {
    guard let characteristicValue = characteristic.value
    else { return }

    if let index = foundCharacteristics.firstIndex(where: {
      $0.uuid.uuidString == characteristic.uuid.uuidString
    }) {
      foundCharacteristics[index].readValue =
        characteristicValue
        .map({ String(format: "%02x", $0) })
        .joined()
    }
  }

  func didWriteValue(
    _ peripheral: CBPeripheralProtocol,
    descriptor: CBDescriptor, error: Error?
  ) {
  }
}
