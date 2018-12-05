import XCTest
@testable import MBUIKit

class MusicBoxTestViewController: UIViewController, StoryboardRepresentable {
    
    static var sbName: String {
        return "MusicBoxTest"
    }
}

class StoryboardRepresentableTests: XCTestCase {
    
    func testStoryBoardInstance() {
        
        XCTAssertEqual(MusicBoxTestViewController.sbBundle, Bundle(for: MusicBoxTestViewController.self))
        XCTAssertNoThrow(MusicBoxTestViewController.loadInstance())
    }
    
    func testIBInspactable() {
        
        let layer = MusicBoxTestViewController.loadInstance().view.layer
        
        XCTAssertEqual(layer.shadowColor, UIColor.green.cgColor)
        XCTAssertEqual(layer.shadowOffset, .init(width: 3, height: 3))
        XCTAssertEqual(layer.shadowRadius, 10)
        XCTAssertEqual(layer.shadowOpacity, 0.5)
        XCTAssertEqual(layer.cornerRadius, 30)
        layer.borderColor = UIColor.red.cgColor
        XCTAssertEqual(layer.borderColor, UIColor.red.cgColor)
        XCTAssertEqual(layer.borderWidth, 3)
    }
}

