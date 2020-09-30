import UIKit

class DataDetector {

    private class func _find(all type: NSTextCheckingResult.CheckingType,
                             in string: String, iterationClosure: (String) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(string.startIndex ..< string.endIndex, in: string)
        let matches = detector.matches(in: string, options: [], range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                guard iterationClosure(String(string[range])) else { break loop }
            }
        }
    }

    class func find(all type: NSTextCheckingResult.CheckingType, in string: String) -> [String] {
        var results = [String]()
        _find(all: type, in: string) {
            results.append($0)
            return true
        }
        return results
    }

    class func first(type: NSTextCheckingResult.CheckingType, in string: String) -> String? {
        var result: String?
        _find(all: type, in: string) {
            result = $0
            return false
        }
        return result
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func dateformat() -> String {
        let date = self.components(separatedBy: "T")[0].components(separatedBy: "-")
        return "\(date[0])/\(date[1])/\(date[2])"
    }
    var detectedLinks: [String] { DataDetector.find(all: .link, in: self) }
    var detectedFirstLink: String? { DataDetector.first(type: .link, in: self) }
    var detectedURLs: [URL] { detectedLinks.compactMap { URL(string: $0) } }
    var detectedFirstURL: URL? {
        guard let urlString = detectedFirstLink else { return nil }
        return URL(string: urlString)
    }
}

extension UIColor {
    public convenience init?(hex: String,alpha : Float) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
                    return
                }
            }
        }
        return nil
    }
}
extension UIButton {
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}

extension NSDictionary {
    func attributeModel() -> Attributes?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(Attributes.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func platformModel() -> Platforms?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(Platforms.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func userModel() -> User?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(User.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func centerModel() -> Centers?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(Centers.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func centerWelcomeModel() -> CenterWelcome?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(CenterWelcome.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func centerLegalModel() -> CenterLegal?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(CenterLegal.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func metaModel() -> Meta?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(Meta.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
    func menuModel() -> Menu?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let launch = try decoder.decode(Menu.self, from: data)
            return launch
        } catch {
          print(error)
        }
        return nil
    }
}
