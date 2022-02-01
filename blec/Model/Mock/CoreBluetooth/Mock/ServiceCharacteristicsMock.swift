import CoreBluetooth
import Foundation

class ServiceCharacteristicsMock {
  private var value: Data = Data([UInt8(0x00)])

  private let serviceUuid: CBUUID = CBUUID(
    string: "00112233-4455-6677-8899-AABBCCDDEEFF")
  private let characteristicUuid: CBUUID = CBUUID(
    string: "10112233-4455-6677-8899-AABBCCDDEEFF")

  public func service() -> [CBMutableService] {
    [
      CBMutableService(type: serviceUuid, primary: true)
    ]
  }

  // TODO: 以下ランダムに作るとかが良いかも
  public func characteristics() -> [CBCharacteristic] {
    [mutableCharacteristic()]
  }

  private func mutableCharacteristic() -> CBMutableCharacteristic {
    CBMutableCharacteristic(
      type: characteristicUuid,
      properties: [.read, .write, .notify],
      value: nil,
      permissions: .readable)
  }
}
