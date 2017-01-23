import Foundation
import UIKit

// Snapshot utilities
extension UIView {
    
    public func addSnapshotView(_ view: UIView, afterUpdates: Bool) -> UIView {
        let snapshot = view.snapshotView(afterScreenUpdates: afterUpdates)
        self.addSubview(snapshot!)
        snapshot?.frame = convert(view.bounds, from: view)
        return snapshot!
    }
    
    public func snapshotViews(_ views: [UIView], afterUpdates: Bool) -> [UIView] {
        return views.map { addSnapshotView($0, afterUpdates: afterUpdates) }
    }
}
