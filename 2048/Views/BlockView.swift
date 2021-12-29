//
//  BlockView.swift
//  2048
//

import SwiftUI

struct BlockView: View {
  @Environment(\.colorScheme) var colorScheme

  // DARK MODE
  fileprivate let colorPaletteDark: [(Color, Color)] = [
    // 2
    (Color(hex: 0xBB9457, opacity: 0.05), Color(white: 1, opacity: 0.6)),
    // 4
    (Color(hex: 0xBB9457, opacity: 0.10), Color(white: 1, opacity: 0.6)),
    // 8
    (Color(hex: 0xBB9457, opacity: 0.20), Color(white: 1, opacity: 0.6)),
    // 16
    (Color(hex: 0xBB9457, opacity: 0.30), Color(white: 1, opacity: 0.6)),
    // 32
    (Color(hex: 0xBB9457, opacity: 0.40), Color(white: 1, opacity: 0.6)),
    // 64
    (Color(hex: 0xBB9457, opacity: 0.50), Color(white: 1, opacity: 0.6)),
    // 128
    (Color(hex: 0xBB9457, opacity: 0.60), Color(white: 1, opacity: 0.6)),
    // 256
    (Color(hex: 0xBB9457, opacity: 0.70), Color(white: 1, opacity: 0.6)),
    // 512
    (Color(hex: 0xBB9457, opacity: 0.80), Color(white: 1, opacity: 0.6)),
    // 1024
    (Color(hex: 0xBB9457, opacity: 0.90), Color(white: 1, opacity: 0.6)),
    // 2048
    (Color(hex: 0xBB9457, opacity: 1.00), Color(white: 1, opacity: 0.6)),
  ]

  // LIGHT MODE
  fileprivate let colorPaletteLight: [(Color, Color)] = [
    // 2
    (Color(red: 0.91, green: 0.87, blue: 0.83), Color(red: 0.42, green: 0.39, blue: 0.35)),
    // 4
    (Color(red: 0.90, green: 0.86, blue: 0.76), Color(red: 0.42, green: 0.39, blue: 0.35)),
    // 8
    (Color(red: 0.93, green: 0.67, blue: 0.46), Color.white),
    // 16
    (Color(red: 0.94, green: 0.57, blue: 0.38), Color.white),
    // 32
    (Color(red: 0.95, green: 0.46, blue: 0.33), Color.white),
    // 64
    (Color(red: 0.94, green: 0.35, blue: 0.23), Color.white),
    // 128
    (Color(red: 0.91, green: 0.78, blue: 0.43), Color.white),
    // 256
    (Color(red: 0.91, green: 0.78, blue: 0.37), Color.white),
    // 512
    (Color(red: 0.90, green: 0.77, blue: 0.31), Color.white),
    // 1024
    (Color(red: 0.91, green: 0.75, blue: 0.24), Color.white),
    // 2048
    (Color(red: 0.91, green: 0.74, blue: 0.18), Color.white),
  ]

  fileprivate let number: Int?

  // This is required to make the Text element be a different
  // instance every time the block is updated. Otherwise, the
  // text will be incorrectly rendered.
  //
  // TODO: File a bug.
  fileprivate let textId: String?

  init(block: IdentifiedBlock) {
    self.number = block.number
    self.textId = "\(block.id):\(block.number)"
  }

  fileprivate init() {
    self.number = nil
    self.textId = ""
  }

  static func blank() -> Self {
    return self.init()
  }

  fileprivate var numberText: String {
    guard let number = number else {
      return ""
    }
    return String(number)
  }

  fileprivate var fontSize: CGFloat {
    let textLength = numberText.count
    if textLength < 3 {
      return 32
    } else if textLength < 4 {
      return 18
    } else {
      return 12
    }
  }

  fileprivate var colorPair: (Color, Color) {
    guard let number = number else {
      // Empty cell
      return (colorScheme == .dark ? Color(hex: 0x17120A) : Color(red: 0.78, green: 0.73, blue: 0.68), Color.black)
    }

    let colorPalette = colorScheme == .dark ? colorPaletteDark : colorPaletteLight
    let index = Int(log2(Double(number))) - 1

    if index < 0 || index >= colorPalette.count {
      fatalError("No color for number \(index)")
    }
    return colorPalette[index]
  }

  // MARK: Body

  var body: some View {
    ZStack {
      Rectangle()
        .fill(colorPair.0)
        .zIndex(1)

      Text(numberText)
        .font(Font.system(size: fontSize).weight(.light))
        .foregroundColor(colorPair.1)
        .id(textId!)
        // `zIndex` is important for removal transition
        .zIndex(2)
        .transition(AnyTransition.opacity.combined(with: .scale))
    }
    .clipped()
    .cornerRadius(6)
  }

}

// MARK: - Previews

#if DEBUG
  struct BlockView_Previews: PreviewProvider {

    static var previews: some View {
      Group {
        ForEach((1...11).map { Int(pow(2, Double($0))) }, id: \.self) { i in
          BlockView(block: IdentifiedBlock(id: 0, number: i))
            .previewLayout(.sizeThatFits)
        }

        BlockView.blank()
          .previewLayout(.sizeThatFits)
      }
    }

  }
#endif
