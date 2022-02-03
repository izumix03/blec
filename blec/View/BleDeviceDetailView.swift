import SwiftUI

struct DetailView: View {
  @EnvironmentObject private var vm: CoreBluetoothViewModel

  var body: some View {
    VStack {
      disconnectButton
      Text(vm.isBlePower ? "" : "Bluetooth設定がOFFです").padding(10)
      List {
        characteristicInfo
      }
      .navigationBarTitle("コネクト結果")
      .navigationBarBackButtonHidden(true)
    }
  }

  private var disconnectButton: some View {
    Button(action: vm.stopScan) {
      Text("切断する")
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue, lineWidth: 4))
    }
  }

  private var characteristicInfo: some View {
    ForEach(vm.foundServices) { service in
      ForEach(
        vm.foundCharacteristics.filter { $0.service?.uuid == service.uuid }
      ) { characteristic in
        Section(header: Text(service.uuid.uuidString)) {
          Button(action: {}) {
            VStack {
              HStack {
                Text("uuid: \(characteristic.uuid.uuidString)")
                  .font(.subheadline)
                  .padding(.bottom, 2)
                Spacer()
              }
              HStack {
                Text("description: \(characteristic.description)")
                .font(.system(size: 14))
                .padding(.bottom, 2)
                Spacer()
              }
              HStack {
                Text("value: \(characteristic.readValue)")
                .font(.system(size: 14))
                .padding(.bottom, 2)
                Spacer()
              }
            }
          }
        }
      }
    }
  }
}

class DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView()
      .environmentObject(CoreBluetoothViewModel())
  }

  #if DEBUG
    @objc class func injected() {
      (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .windows.first?.rootViewController =
        UIHostingController(
          rootView:
            DetailView()
            .environmentObject(CoreBluetoothViewModel())
        )
    }
  #endif
}
