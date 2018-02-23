//
//  Double+Utility.swift
//  RABLib
//
//  Created by skylinefighterx on 2/23/18.
//  Copyright © 2018 Rab LLC. All rights reserved.
//

import Foundation

extension Double {
    public var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
