import Combine
import SwiftUI
import XCTest
@testable import Republished

// MARK: - PassthroughTests

@MainActor
final class PassthroughTests: XCTestCase {

  // MARK: Internal

  override func setUpWithError() throws {
    willChangeCount = 0
    outerObject = OuterObject()
    object = outerObject.object
    cancellable = outerObject.objectWillChange
      .sink {
        self.willChangeCount += 1
      }
  }

  override func tearDownWithError() throws {
    willChangeCount = nil
    object = nil
    cancellable = nil
  }

  func test_isRepublishedOnChange() {
    XCTAssertEqual(willChangeCount, 0)
    object.x = 100
    XCTAssertEqual(willChangeCount, 1)
  }

  func test_isRepublishedOnChange_whenPrivateSet() {
    XCTAssertEqual(willChangeCount, 0)
    object.setY("goodbye")
    XCTAssertEqual(willChangeCount, 1)
  }

  func test_isRepublishedOnChange_whenModifiedWithBinding() {
    XCTAssertEqual(willChangeCount, 0)
    let x = outerObject.$object.x
    x.wrappedValue = 20
    XCTAssertEqual(willChangeCount, 1)
  }

  // MARK: Private

  @ObservedObject private var outerObject = OuterObject()
  private var object: RepublishedObject!
  private var willChangeCount: Int!
  private var cancellable: AnyCancellable!

}

// MARK: - OuterObject

private final class OuterObject: ObservableObject {
  @Republished var object = RepublishedObject()
}

// MARK: - RepublishedObject

private final class RepublishedObject: ObservableObject {
  @Published var x = 10
  @Published private(set) var y = "Hello"

  func setY(_ value: String) {
    y = value
  }
}
