//
//  Hockey_Dairy_ApplicationApp.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      UITabBar.appearance().isTranslucent = true
      return true
  }
}

@main
struct Hockey_Dairy_ApplicationApp: App {
    let persistenceController = HDCoreDataManager.shared
    @ObservedObject var model = Hockey_Dairy_ApplicationAppVM()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            VStack(content: {
                if let state = model.state {
                HDSplashV(sOnboarding: state)
                        .environment(\.managedObjectContext, persistenceController.hdContainer.viewContext)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.cellBorderBackground)
            .ignoresSafeArea()
            .onAppear(perform: {
                HDNetworkManager.shared.hdEventRequest { event in
                    model.state = event
                }
            })
        }
    }
}

class Hockey_Dairy_ApplicationAppVM: ObservableObject {
    @Published var state: Bool?
}
