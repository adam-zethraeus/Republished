import Combine
import SwiftUI
import XCTest
@testable import Republished

// MARK: - ArrayTests

@MainActor
final class ArrayTests: XCTestCase {

  // MARK: Internal

  override func setUpWithError() throws {
    willChangeCount = 0
    outerObject = OuterObject()
    objects = outerObject.objects
    cancellable = outerObject.objectWillChange
      .sink {
        self.willChangeCount += 1
      }
  }

  override func tearDownWithError() throws {
    willChangeCount = nil
    objects = nil
    cancellable = nil
  }

  func test_isRepublishedOnChange() {
    XCTAssertEqual(willChangeCount, 0)
    objects.first?.x = 1
    XCTAssertEqual(willChangeCount, 1)
  }

  func test_isRepublishedOnChange_whenPrivateSet() {
    XCTAssertEqual(willChangeCount, 0)
    objects.first?.setY("goodbye")
    XCTAssertEqual(willChangeCount, 1)
  }

  func test_isRepublishedOnChange_whenModifiedWithBinding() {
    XCTAssertEqual(willChangeCount, 0)
    let x = outerObject.$objects.first?.x
    x?.wrappedValue = 20
    XCTAssertEqual(willChangeCount, 1)
  }

  // MARK: Private

  @ObservedObject private var outerObject = OuterObject()
  private var objects: [RepublishedObject]!
  private var willChangeCount: Int!
  private var cancellable: AnyCancellable!

}

// MARK: - OuterObject

private final class OuterObject: ObservableObject {
  @Republished var objects = [RepublishedObject(), RepublishedObject(), RepublishedObject()]
}

// MARK: - RepublishedObject

private final class RepublishedObject: ObservableObject {
  @Published var x = 10
  @Published private(set) var y = "Hello"

  func setY(_ value: String) {
    y = value
  }
}
