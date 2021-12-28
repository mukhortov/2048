//
//  SwiftUIExtensions.swift
//  2048
//

import SwiftUI

extension View {

  func eraseToAnyView() -> AnyView {
    return AnyView(self)
  }

}

postfix operator >*
postfix func >* <V>(lhs: V) -> AnyView where V: View {
  return lhs.eraseToAnyView()
}

extension Color {
  init(hex: Int, opacity: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xff) / 255,
      green: Double((hex >> 08) & 0xff) / 255,
      blue: Double((hex >> 00) & 0xff) / 255,
      opacity: opacity
    )
  }
}
