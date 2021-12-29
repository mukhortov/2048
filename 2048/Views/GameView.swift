//
//  GameView.swift
//  2048
//

import SwiftUI

extension Edge {

  static func from(_ from: GameLogic.Direction) -> Self {
    switch from {
      case .down:
        return .top
      case .up:
        return .bottom
      case .left:
        return .trailing
      case .right:
        return .leading
    }
  }

}

struct GameView: View {

  @State var ignoreGesture = false
  @EnvironmentObject var gameLogic: GameLogic
  @Environment(\.colorScheme) var colorScheme

  fileprivate struct LayoutTraits {
    let bannerOffset: CGSize
    let showsBanner: Bool
    let containerAlignment: Alignment
  }

  fileprivate func layoutTraits(for proxy: GeometryProxy) -> LayoutTraits {
    #if os(macOS) || targetEnvironment(macCatalyst)
      let landscape = false
    #else
      let landscape = proxy.size.width > proxy.size.height
    #endif

    return LayoutTraits(
      bannerOffset: landscape
        ? .init(width: 32, height: 0)
        : .init(width: 0, height: (proxy.size.height - 400) / 2),
      // TODO: refactor this. Probably not needed
      showsBanner: landscape ? proxy.size.width > 720 : proxy.size.height > 400,
      containerAlignment: landscape ? .leading : .top
    )
  }

  var gestureEnabled: Bool {
    #if os(macOS) || targetEnvironment(macCatalyst)
      return false
    #else
      return true
    #endif
  }

  var gesture: some Gesture {
    let threshold: CGFloat = 44
    let drag = DragGesture()
      .onChanged { v in
        guard !self.ignoreGesture else {
          return
        }

        guard abs(v.translation.width) > threshold || abs(v.translation.height) > threshold else {
          return
        }

        withTransaction(Transaction(animation: .spring())) {
          self.ignoreGesture = true

          if v.translation.width > threshold {
            // Move right
            self.gameLogic.move(.right)
          } else if v.translation.width < -threshold {
            // Move left
            self.gameLogic.move(.left)
          } else if v.translation.height > threshold {
            // Move down
            self.gameLogic.move(.down)
          } else if v.translation.height < -threshold {
            // Move up
            self.gameLogic.move(.up)
          }
        }
      }
      .onEnded { _ in
        self.ignoreGesture = false
      }
    return drag
  }

  var content: some View {
    GeometryReader { proxy in
      bind(self.layoutTraits(for: proxy)) { layoutTraits in
        ZStack(alignment: layoutTraits.containerAlignment) {
          if layoutTraits.showsBanner {
            Text("Score: \(self.gameLogic.score)")
              .font(Font.system(size: 18).weight(.light))
              .foregroundColor(Color(white: colorScheme == .dark ? 1 : 0, opacity: 0.4))
              .offset(layoutTraits.bannerOffset)
          }
          ZStack(alignment: .center) {
            BlockGridView(
              matrix: self.gameLogic.blockMatrix,
              blockEnterEdge: .from(self.gameLogic.lastGestureDirection)
            )
          }
          .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        .background(
          // Page background
          Rectangle()
            .fill(colorScheme == .dark ? Color(hex: 0x17120A) : Color(red: 0.96, green: 0.94, blue: 0.90))
            .edgesIgnoringSafeArea(.all)
        )
      }
    }
  }

  var body: AnyView {
    return gestureEnabled
      ? content.gesture(gesture, including: .all)>*
      : content>*
  }

}

#if DEBUG
  struct GameView_Previews: PreviewProvider {

    static var previews: some View {
      GameView().environmentObject(GameLogic())
    }

  }
#endif
