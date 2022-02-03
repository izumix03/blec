//
// Created by mix on 2022/01/27.
//

import CoreBluetooth
import SwiftUI

extension CoreBluetoothViewModel {
  func navigationToDetailView(isActive: Binding<Bool>) -> some View {
    NavigationLink(
      "",
      destination: DetailView(),
      isActive: isActive
    ).frame(width: 0, height: 0)
  }
}
