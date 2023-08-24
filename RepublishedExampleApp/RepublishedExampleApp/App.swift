import SwiftUI

@main
struct RepublishTestApp: App {

  var body: some Scene {
    WindowGroup {
      // Example showing an outer ObservableObject (ViewModel) nesting an inner ObservableObject
      // (DomainModel).
      ContentView(viewModel: ViewModel(model: DomainModel()))

      // Example showing nesting of an optional, that may or may not contain an inner
      // ObservableObject
      OptionalExampleContentView(viewModel: OptionalExampleViewModel(
        optionalModel: Bool.random()
          ? DomainModel()
          : nil
      ))

      // Example showing nesting of an array, that may contain 0 to 5 inner ObservableObjects.
      ArrayExampleContentView(viewModel: ArrayExampleViewModel(models: Array(
        repeating: (),
        count: Int.random(in: 0 ... 5)
      ).map { _ in DomainModel() }))
    }
  }
}
