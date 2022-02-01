import SwiftUI

struct BleDeviceListView: View {
  @EnvironmentObject private var vm: CoreBluetoothViewModel

  var body: some View {
    NavigationView {
      ZStack {
        vm.navigationToDetailView(isActive: $vm.isConnected)
        VStack {
          scanButton
          bleStatus
          peripheralCells
        }.padding()
      }.navigationTitle("BLEデバイス")
    }.navigationViewStyle(StackNavigationViewStyle())
  }

  private var scanButton: some View {
    Button(action: {
      vm.isSearching ? vm.stopScan() : vm.startScan()
    }) {
      Text(vm.isSearching ? "スキャン停止" : "スキャン開始")
    }
  }

  private var bleStatus: some View {
    Text(vm.isBlePower ? "" : "Bluetooth設定がOFFになっています")
  }

  private var peripheralCells: some View {
    List {
      ForEach(vm.foundPeripherals) { peripheral in
        Button(action: {
          vm.connect(peripheral)
        }) {
          HStack {
            Text("\(peripheral.name)")
            Spacer()
            Text("\(peripheral.rssi) dBm")
          }
        }
      }
    }
  }
}

class BleDeviceListView_Previews: PreviewProvider {
  static var previews: some View {
    BleDeviceListView().environmentObject(
      CoreBluetoothViewModel())
  }

  #if DEBUG
    @objc class func injected() {
      (UIApplication.shared.connectedScenes.first
        as? UIWindowScene)?
        .windows.first?.rootViewController =
        UIHostingController(
          rootView:
            BleDeviceListView()
            .environmentObject(CoreBluetoothViewModel())
        )
    }
  #endif
}
