//
//  SwiftUIView.swift
//  
//
//  Created by yun on 2/25/24.
//

import SwiftUI

enum Quotes: CaseIterable {
  
  case quote1
  case quote2
  case quote3
  
  var text: String {
    switch self {
    case .quote1: "If you can imagine it, you can achieve it. \nIf you can dream it, you can become it."
    case .quote2: "Imagination is your invisible power \nto produce all things powerful."
    case .quote3: "Without leaps of imagination, or dreaming, we lose the excitement of possibilities. Dreaming, after all, is a form of planning."
    }
  }
  
  var author: String {
    switch self {
    case .quote1: "William Arthur Ward"
    case .quote2: "Hiral Nagda"
    case .quote3: "Gloria Steinem"
    }
  }
}
