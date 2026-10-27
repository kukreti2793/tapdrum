import AppKit
import SwiftUI

@main
@MainActor
struct TapDrumApp: App {
    @NSApplicationDelegateAdaptor(ApplicationDelegate.self) private var appDelegate
    @StateObject private var model = CameraModel()

    var body: some Scene {
        WindowGroup("TapDrum · Hand Tracking") {
            ContentView(model: model)
                .frame(minWidth: 1000, minHeight: 720)
                .onAppear {
                    appDelegate.model = model
                    model.refreshDevices()
                }
        }
        .defaultSize(width: 1180, height: 820)
        .commands { CommandGroup(replacing: .newItem) {} }
    }
}

@MainActor
final class ApplicationDelegate: NSObject, NSApplicationDelegate {
    weak var model: CameraModel?

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let model else { return .terminateNow }
        model.stop { sender.reply(toApplicationShouldTerminate: true) }
        return .terminateLater
    }
}
