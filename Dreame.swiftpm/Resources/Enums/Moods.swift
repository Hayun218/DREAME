//
//  SwiftUIView.swift
//
//
//  Created by yun on 2/25/24.
//

import SwiftUI

enum Moods: String, CaseIterable {
  
  case happy
  case normal
  case sad
  case angry
  
  var text: String {
    switch self {
    case .happy: "Happy"
    case .normal: "Normal"
    case .sad: "Sad"
    case .angry: "Angry"
    }
  }
  
  
}
