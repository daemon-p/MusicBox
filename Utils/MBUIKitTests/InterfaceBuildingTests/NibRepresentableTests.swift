import XCTest
@testable import MBUIKit

var _nibName: String {
    return "MusicBoxTest"
}

class MusicBoxTestView0: UIView, NibPresentable {
    static var nibName: String {
        return _nibName
    }
}

class MusicBoxTestView1: UIView, NibPresentable {
    
    static var nibName: String {
        return _nibName
    }
    
    static var nibIndex: Int? {
        return 1
    }
}

class MusicBoxTestView2: UIView, NibPresentable {
}

class NibRepresentableTests: XCTestCase {
    
    func testNibIntance() {
        XCTAssertNoThrow(MusicBoxTestView0.nibInstance())
        XCTAssertNoThrow(MusicBoxTestView1.nibInstance())
        XCTAssertNoThrow(MusicBoxTestView2.nibInstance())
    }
}
