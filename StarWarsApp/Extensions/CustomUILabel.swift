import UIKit

extension UILabel {
    // Extension to make borders with labels
    public func makeBorder() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
    }
}
