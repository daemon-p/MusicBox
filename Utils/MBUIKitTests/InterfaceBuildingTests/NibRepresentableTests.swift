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
    
    @IBOutlet weak var label: UILabel!
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
//        XCTAssertNotNil(MusicBoxTestView0.nibInstance())
        XCTAssertNotNil(MusicBoxTestView1.nibInstance())
//        MusicBoxTestView1.nibInstance()?.label

        XCTAssertNotNil(MusicBoxTestView2.nibInstance())
    }
}
