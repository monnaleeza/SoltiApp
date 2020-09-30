import Foundation
import XCTest
@testable import MadeoGenes
class SelectCenterTest: XCTestCase {
    var centers : Centers?
    var meta : Meta?
    let centerJsonObject: [Any]  = [
         [
             "slug": "FD1",
             "name": "Frontdesk 1",
             "language": "en",
             "logoUrl": "https://genomcore.com/wp-content/uploads/sites/8/2018/03/logo-genomcore.png",
             "rss": "https://www.lavanguardia.com/mvc/feed/rss/vida/salud",
             "rssLimit": 5,
             "hasWelcome": true
         ],
         [
             "slug": "FD2",
             "name": "Frontdesk 2",
             "language": "en",
             "logoUrl": "https://genomcore.com/wp-content/uploads/sites/8/2018/03/logo-genomcore.png",
             "rss": "https://www.lavanguardia.com/mvc/feed/rss/vida/salud",
             "rssLimit": 5,
             "hasWelcome": true
         ]
     ]
    let metaJsonObject  = [
        "welcomeAccepted": true,
        "legalAccepted": true
    ]
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        
    }
    func testSuccessGetCenterZero() {
        let count = self.centerJsonObject.count
        XCTAssertFalse(!(count != 0))
    }
    func testFailGetCenterZero() {
        let count = self.centerJsonObject.count
        XCTAssertTrue((count != 0))
    }
    func testSuccessGetCenterOne() {
        let count = self.centerJsonObject.count
        XCTAssertFalse(!(count != 1))
    }
    func testFailGetCenterOne() {
        let count = self.centerJsonObject.count
        XCTAssertTrue((count != 1))
    }
    func testSuccessGetCenterOneMore() {
        let count = self.centerJsonObject.count
        XCTAssertTrue((count >= 2))
    }
    func testFailGetCenterOneMore() {
        let count = self.centerJsonObject.count
        XCTAssertFalse(!(count >= 2))
    }
    func testSuccessCenterHasWelcome() {
        let dict = centerJsonObject[0] as! NSDictionary
        self.centers = dict.centerModel()
        let haswelcome = self.centers?.hasWelcome
        XCTAssertTrue((haswelcome != nil))
    }
    func testFailCenterHasWelcome() {
        let dict = centerJsonObject[0] as! NSDictionary
        self.centers = dict.centerModel()
        let haswelcome = self.centers?.hasWelcome
        XCTAssertFalse(!(haswelcome != nil))
    }
    func testSuccessWelcomeAccepted() {
        let dict = metaJsonObject as NSDictionary
        self.meta = dict.metaModel()
        let welcomAccepted = self.meta?.welcomeAccepted
        XCTAssertTrue((welcomAccepted != nil))
    }
    func testFailWelcomeAccepted() {
        let dict = metaJsonObject as NSDictionary
        self.meta = dict.metaModel()
        let welcomAccepted = self.meta?.welcomeAccepted
        XCTAssertFalse(!(welcomAccepted != nil))
    }
    func testSuccessLegalAccepted() {
        let dict = metaJsonObject as NSDictionary
        self.meta = dict.metaModel()
        let legalAccepted = self.meta?.legalAccepted
        XCTAssertTrue((legalAccepted != nil))
    }
    func testFailLegalAccepted() {
        let dict = metaJsonObject as NSDictionary
        self.meta = dict.metaModel()
        let legalAccepted = self.meta?.legalAccepted
        XCTAssertFalse(!(legalAccepted != nil))
    }
}
