import UIKit
import Foundation
import Toast
func showToast(_ message: String) {
    let windows = UIApplication.shared.windows
    windows.last?.makeToast(message)
}
