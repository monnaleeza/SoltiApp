import Foundation
import XCTest
@testable import MadeoGenes

class ForgotPasswordTest: XCTestCase {

    var apiHandler = WebServices.shared
     override func setUp() {
         super.setUp()
         
     }
     
     func testInValidEmail() throws {
         let tmpEmail = "irene.gonzalez"
         XCTAssertTrue(!tmpEmail.isValidEmail())
     }
     
     func testValidEmail() {
         let tmpEmail = "irene.gonzalez@genomcore.com"
         XCTAssertTrue(tmpEmail.isValidEmail())
     }
     
     func testEmptyEmail() {
         let tmpEmail = ""
         XCTAssertTrue(tmpEmail.isEmpty)
     }
     
     func testNotEmptyEmail(){
         let tmpEmail = "irene.gonzalez@genomcore.com"
         XCTAssertTrue(!tmpEmail.isEmpty)
     }
         
     func testEmptyFields(){
         let tmpEmail = ""
         
         XCTAssertTrue(tmpEmail.isEmpty)
     }
         
     override func tearDown() {
         
     }
     
     
     func testPlatforms()
     {
         let platformId = 2
         let e = expectation(description: "Alamofire")
         apiHandler.getPlatforms(platformId) { (success, statusCode, response, detail, message) in
             XCTAssertTrue(statusCode == 200)
             e.fulfill()
         }
         waitForExpectations(timeout: 5.0) { (error) in
             XCTAssert(error == nil, "Expected no error")
         }
     }
     
     func testFailedRequestPassword()
     {
         let email = "val2019522@gmail.com1"
         let platform = "frontdesk"
         let e = expectation(description: "Alamofire")
         apiHandler.sendResetPasswordLink(email, platform: platform) { (success, statusCode, response, detail, message) in
             XCTAssertTrue(statusCode == 404)
             e.fulfill()
         }
         waitForExpectations(timeout: 5.0) { (error) in
             XCTAssert(error == nil, "Expected no error")
         }
     }
     
    
     func testSuccessRequestPassword()
     {
         let email = "val2019522@gmail.com"
         let platform = "frontdesk"
         let e = expectation(description: "Alamofire")
         apiHandler.sendResetPasswordLink(email, platform: platform) { (success, statusCode, response, detail, message) in
             XCTAssertTrue(statusCode == 202)
             e.fulfill()
         }
         waitForExpectations(timeout: 5.0) { (error) in
             XCTAssert(error == nil, "Expected no error")
         }
     }

}
