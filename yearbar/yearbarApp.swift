//
//  yearbarApp.swift
//  yearbar
//
//  Created by Prakash Pawar on 23/10/24.
//
// yearbarApp.swift
// yearbarApp.swift
// yearbarApp.swift

// yearbarApp.swift

// yearbarApp.swift
import SwiftUI

@main
struct YearBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: 80)
        
        if let button = statusItem?.button {
            // Create a custom view for the status bar
            let customView = YearProgressView(frame: NSRect(x: 0, y: 0, width: 80, height: 18))
            button.addSubview(customView)
            
            // Create menu
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            statusItem?.menu = menu
            
            // Update every hour
            timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
                customView.updateProgress()
            }
            customView.updateProgress() // Initial update
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        timer?.invalidate()
    }
}

class YearProgressView: NSView {
    private let progressLayer = CALayer()
    private let backgroundLayer = CALayer()
    private let textLayer = CATextLayer()
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        wantsLayer = true
        layer?.cornerRadius = 4
        
        // Background layer
        backgroundLayer.backgroundColor = NSColor.darkGray.withAlphaComponent(0.3).cgColor
        backgroundLayer.cornerRadius = 4
        layer?.addSublayer(backgroundLayer)
        
        // Progress layer
        progressLayer.backgroundColor = NSColor.systemBlue.cgColor
        progressLayer.cornerRadius = 4
        layer?.addSublayer(progressLayer)
        
        // Text layer for percentage
        textLayer.fontSize = 10
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = NSColor.white.cgColor
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        textLayer.truncationMode = .end
        textLayer.alignmentMode = .center // Ensure horizontal centering
        layer?.addSublayer(textLayer)
    }
    
    override func layout() {
        super.layout()
        backgroundLayer.frame = bounds
        updateProgress()
    }
    
    func updateProgress() {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)
        
        // Calculate progress
        guard let startOfYear = calendar.date(from: DateComponents(year: year)),
              let endOfYear = calendar.date(from: DateComponents(year: year + 1)) else {
            return
        }
        
        let totalSeconds = endOfYear.timeIntervalSince(startOfYear)
        let elapsedSeconds = now.timeIntervalSince(startOfYear)
        let progress = elapsedSeconds / totalSeconds
        
        // Update progress bar width
        let progressWidth = bounds.width * CGFloat(progress)
        progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
        
        // Update text
        let percentage = Int(progress * 100)
        textLayer.string = "\(percentage)%"
        
        // Center the text vertically
        textLayer.frame = CGRect(x: 0, y: (bounds.height - textLayer.fontSize) / 2 - 2, width: bounds.width, height: textLayer.fontSize + 4) // Adjust y position for vertical centering

        // Update tooltip
        toolTip = "\(percentage)% of \(year) completed"
    }
}
