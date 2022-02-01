//
// Created by mix on 2022/01/28.
//

import CoreBluetooth

class CBPeripheralMock: Mock, CBPeripheralProtocol {
  weak var delegate: CBPeripheralDelegate?
  var identifier: UUID
  var name: String?
  var rssi: NSNumber? = nil
  var services: [CBService]? = nil
  var canSendWriteWithoutResponse: Bool = true
  var ancsAuthorized: Bool = true

  private let mockProvider = ServiceCharacteristicsMock()

  init(identifier: UUID, name: String?) {
    self.identifier = identifier
    self.name = name
  }

  func discoverServices(_ serviceUUIDs: [CBUUID]?) {
    log(#function)
    services = mockProvider.service()
    guard let delegate = delegate as? CBPeripheralProtocolDelegate else {
      return
    }
    delegate.didDiscoverServices(self, error: nil)
  }

  func discoverCharacteristics(
    _ characteristicUUIDs: [CBUUID]?, for service: CBService
  ) {
    log(#function)
    guard let mutableService = service as? CBMutableService,
      let delegate = delegate as? CBPeripheralProtocolDelegate
    else { return }
    mutableService.characteristics = mockProvider.characteristics()
    delegate.didDiscoverCharacteristics(
      self, service: mutableService, error: nil)
  }

  func readValue(for characteristic: CBCharacteristic) {
    log(#function)
    guard
      let mutableCharacteristic = characteristic as? CBMutableCharacteristic,
      let delegate = delegate as? CBPeripheralProtocolDelegate
    else { return }

    if mutableCharacteristic.value?.isEmpty ?? true { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      delegate.didUpdateValue(
        self,
        characteristic: characteristic,
        error: nil)
    }
  }

  func writeValue(
    _ data: Data, for characteristic: CBCharacteristic,
    type: CBCharacteristicWriteType
  ) {
    log(#function)
    guard
      let mutableCharacteristic = characteristic as? CBMutableCharacteristic,
      let delegate = delegate as? CBPeripheralProtocolDelegate
    else { return }

    mutableCharacteristic.value = data
    if data.isEmpty { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      delegate.didUpdateValue(
        self,
        characteristic: characteristic,
        error: nil)
    }
  }

  func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic) {
    log(#function)
  }

  func discoverDescriptors(for characteristic: CBCharacteristic) {
    log(#function)
  }
}
