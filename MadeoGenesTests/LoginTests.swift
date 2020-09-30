import Foundation
import XCTest

@testable import MadeoGenes


class LoginTest: XCTestCase{
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
    
    func testEmptyPassword(){
        let tmpPassword = ""
        XCTAssertTrue(tmpPassword.isEmpty)
    }
    
    func testNotEmptyPassword(){
        let tmpPassword = "A12345678"
        XCTAssertTrue(!tmpPassword.isEmpty)
    }
    
    func testEmptyFields(){
        let tmpPassword = ""
        let tmpEmail = ""
        
        XCTAssertTrue(tmpPassword.isEmpty || tmpEmail.isEmpty)
    }
    
    func testEmptyEmailField(){
        let tmpPassword = "21324313131"
        let tmpEmail = ""
        
        XCTAssertTrue(tmpPassword.isEmpty || tmpEmail.isEmpty)
    }
    
    func testEmptyPasswordFields()
    {
        let tmpPassword = ""
        let tmpEmail = "irene.gonzalez@genomcore.com"
        
        XCTAssertTrue(tmpPassword.isEmpty || tmpEmail.isEmpty)
    }
    
    func testNotEmptyFields()
    {
        let tmpPassword = "123456789"
        let tmpEmail = "irene.gonzalez@genomcore.com"
        
        XCTAssertTrue(!tmpPassword.isEmpty || !tmpEmail.isEmpty)
    }
    
    func testPasswordTooLong()
    {
        let tmpPassword = "A123456788738383823233"
        XCTAssertTrue(tmpPassword.count > 15)
    }
    
    func testPasswordIsSmall()
    {
        let tmpPassword = "A123"
        XCTAssertTrue(tmpPassword.count < 8)
    }
    
    func testValidPassword()
    {
        let tmpPassword = "A12345678"
        XCTAssertTrue(tmpPassword.count < 15 && tmpPassword.count > 8)
    }
    
    
    override func tearDown() {
        
    }
    
    
    func testUserNotFound()
    {
        let email = "irene.gonzalellz@genomcore.com"
        let password =  "aaa111AAA"
        let e = expectation(description: "Alamofire")
        apiHandler.loginData(email, password: password) { (success, statusCode, response, detail, message) in
            XCTAssertTrue(statusCode == 404)
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssert(error == nil, "Expected no error")
        }
    }
    
    func testSuccessLogin()
    {
        let email = "irene.gonzalez@genomcore.com"
        let password =  "aaa111AAA$"
        let e = expectation(description: "Alamofire")
        apiHandler.loginData(email, password: password) { (success, statusCode, response, detail, message) in
            XCTAssertTrue(statusCode == 201)
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssert(error == nil, "Expected no error")
        }
    }
}
