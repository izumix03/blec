//
// Created by mix on 2022/01/28.
//

protocol Mock {}

extension Mock {
  var className: String {
    String(describing: type(of: self))
  }

  func log(_ message: String? = nil) {
    print("Mocked -", className, message ?? "")
  }
}

