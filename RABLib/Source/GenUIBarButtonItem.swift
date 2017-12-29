//
//  Created by RAB on 3/20/15.
//  Copyright (c) 2015 RAB LLC. All rights reserved.
//

import Foundation
import UIKit

/**
    EX: 
 navigationItem.leftBarButtonItem = GenUIBarButtonItem(style: UIBarButtonItemStyle.Plain, title: "Cancel", image: nil, landscapeImage: nil, touchAction: { () -> () in
 self.dismissViewControllerAnimated(true, completion: nil)
 })
 */
open class GenUIBarButtonItem: UIBarButtonItem {
    
    var touchAction: Action = {}
    
    // MARK: - UIView
    //
    public required init(coder: NSCoder) {
        // WARNING: archived instances do not preserve any action closures, so we expect them to be set up after decode.
        super.init(coder: coder)!
        helpInit()
    }
    
    /**
     Note: 
     There is a apple bug where the leftBarButton shifts down when you are using
     it.  It happens when a image is used and the title is not set to nil. So
     pass nil.
     
     http://stackoverflow.com/questions/33748538/uialertcontroller-moves-leftbarbuttonitem-down
     */
    public init(style: UIBarButtonItemStyle = .plain, title: String? = nil,
        image: UIImage? = nil, landscapeImage: UIImage? = nil,
        touchAction: Action? = nil) {
        
        super.init()
        helpInit()
        self.style = style
        self.title = title
        self.image = image
        self.landscapeImagePhone = landscapeImage
        if let a = touchAction {
            self.touchAction = a
        }

    }
    
    open func helpInit() {
        target = self
        action = #selector(GenUIBarButtonItem.handleAction)
    }
    
    @objc open func handleAction() {
        touchAction()
    }
    
}
