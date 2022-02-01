//
// Created by mix on 2022/02/01.
//

import CoreBluetooth

class Service: Identifiable {
  var id: UUID
  var uuid: CBUUID
  var service: CBService

  init(_uuid: CBUUID, _service: CBService) {
    id = UUID()
    uuid = _uuid
    service = _service
  }
}
