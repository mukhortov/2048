//
//  AppDelegate.swift
//  2048-mac
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = NSWindow(
      // Window min and max size are set in GameMainHostingView.swift
      contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
      styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
      backing: .buffered, defer: false
    )
    window.titlebarAppearsTransparent = true
    window.isMovableByWindowBackground = true
    window.center()
    window.setFrameAutosaveName("Main Window")

    window.contentView = GameMainHostingView()

    window.makeKeyAndOrderFront(nil)
    window.makeFirstResponder(window.contentView)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }

  @objc func newGame(_ sender: Any?) {
    (window.contentView as? GameMainHostingView)?.newGame()
  }

}
