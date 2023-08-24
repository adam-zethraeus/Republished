import SwiftUI

// MARK: - OptionalExampleContentView

struct OptionalExampleContentView: View {

  // Regular direct use of outer ObservableObject

  @StateObject var viewModel: OptionalExampleViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 24) {
        Spacer()
        Text(viewModel.countString)
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
            text: "count += 1"
          ) {
            viewModel.increment()
          }
          CapsuleButton(
            bg: (0, 1, 0, 0),
            fg: 1,
            text: "count -= 1"
          ) {
            viewModel.decrement()
          }
          CapsuleButton(
            bg: (0, 0, 1, 0),
            fg: 0,
            text: "count = rand()"
          ) {
            viewModel.rand()
          }
          CapsuleButton(
            bg: (0, 0, 0, 1),
            fg: 1,
            text: "count = 0"
          ) {
            viewModel.zero()
          }
          Spacer()
        }
      }
      .frame(maxWidth: .infinity)
    }
    .background(.gray.opacity(0.6))
  }
}

// MARK: - OptionalExampleContentView_Previews

struct OptionalExampleContentView_Previews: PreviewProvider {
  static var previews: some View {
    OptionalExampleContentView(viewModel: OptionalExampleViewModel(optionalModel: nil))
  }
}
