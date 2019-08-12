import UIKit

extension UILabel {
    public func makeBorder() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
    }
}
