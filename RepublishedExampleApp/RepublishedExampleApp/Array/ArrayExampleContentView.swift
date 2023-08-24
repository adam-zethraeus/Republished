import SwiftUI

// MARK: - ArrayExampleContentView

struct ArrayExampleContentView: View {

  // Regular direct use of outer ObservableObject

  @StateObject var viewModel: ArrayExampleViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 24) {
        Spacer()
        Text(viewModel.count)
          .font(.title)
          .fontWeight(.bold)
          .scaledToFit()
        Text(viewModel.info)
          .font(.body.monospaced())
        Spacer()
        VStack(alignment: .center, spacing: 24) {
          Spacer()
          CapsuleButton(
            bg: (1, 0, 0, 0),
            fg: 1,
            text: "increment all models"
          ) {
            viewModel.incrementAll()
          }
          CapsuleButton(
            bg: (0, 1, 0, 0),
            fg: 1,
            text: "decrement all models"
          ) {
            viewModel.decrementAll()
          }
          CapsuleButton(
            bg: (0, 0, 0, 1),
            fg: 1,
            text: "zero out all models"
          ) {
            viewModel.zeroAll()
          }
          Spacer()
        }
      }
      .frame(maxWidth: .infinity)
    }
    .background(.gray.opacity(0.6))
  }
}

// MARK: - ArrayExampleContentView_Previews

struct ArrayExampleContentView_Previews: PreviewProvider {
  static var previews: some View {
    ArrayExampleContentView(viewModel: ArrayExampleViewModel(models: Array(
      repeating: (),
      count: Int.random(in: 0 ... 5)
    ).map { _ in DomainModel() }))
  }
}
