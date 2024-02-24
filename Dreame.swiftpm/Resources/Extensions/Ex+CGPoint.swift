//
//  SwiftUIView.swift
//  
//
//  Created by yun on 2/25/24.
//

import SwiftUI

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
