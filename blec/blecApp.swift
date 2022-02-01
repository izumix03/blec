//
//  blecApp.swift
//  blec
//
//  Created by mix on 2022/01/27.
//
//

import SwiftUI

@main
struct blecApp: App {
  init() {
    #if DEBUG
      var injectionBundlePath =
        "/Applications/InjectionIII.app/Contents/Resources"
      #if targetEnvironment(macCatalyst)
        injectionBundlePath =
          "\(injectionBundlePath)/macOSInjection.bundle"
      #elseif os(iOS)
        injectionBundlePath =
          "\(injectionBundlePath)/iOSInjection.bundle"
      #endif
      Bundle(path: injectionBundlePath)?.load()
    #endif
  }

  var body: some Scene {
    WindowGroup {
      BleDeviceListView()
        .environmentObject(CoreBluetoothViewModel())
    }
  }
}
