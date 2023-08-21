import SwiftUI

@main
struct RepublishTestApp: App {

  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: ViewModel(model: DomainModel()))
    }
  }
}
