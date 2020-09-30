import Foundation
import XCTest
@testable import MadeoGenes
import XCTest

class WelcomeCenterTest: XCTestCase {
    var centerWelcome : CenterWelcome?
    var centerLegal : CenterLegal?
    let centerLegalJsonObject: [String:Any]  = [
        "text": "<p>Updated text</p>",
        "updatedAt": "1970-01-19T12:20:53.106Z"
    ]
    let centerWelcomeJsonObject: [String:Any]  = [
        "title": "Bienvenido",
        "text": "Bienvenido a HOPE. Estudio de clínica práctica en el mundo real para evaluar el impacto del uso de datos genómicos para tomar decisiones en tumores de mama localmente avanzados o metastásicos",
        "media": [
            "type": "YOUTUBE",
            "url": "https://youtu.be/OZV-VBHf_xo"
        ],
        "readMore": [
            "text": "Leer más",
            "url": "http://www.gruposolti.org/es_ES/investigacion/-/research/HOPE"
        ],
        "actionButton": [
            "text": "Aceptar",
            "uri": "surveys/"
        ]
    ]
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        
    }
    func testSuccessDisplayTitle (){
       let dict = centerWelcomeJsonObject as NSDictionary
        self.centerWelcome = dict.centerWelcomeModel()
        let title = self.centerWelcome?.title
        XCTAssertTrue(!title!.isEmpty)
    }
    func testFailDisplayTitle (){
       let dict = centerWelcomeJsonObject as NSDictionary
        self.centerWelcome = dict.centerWelcomeModel()
        let title = self.centerWelcome?.title
        XCTAssertFalse(title!.isEmpty)
    }
    func testSuccessDisplayText (){
       let dict = centerWelcomeJsonObject as NSDictionary
        self.centerWelcome = dict.centerWelcomeModel()
        let text = self.centerWelcome?.text
        XCTAssertTrue(!text!.isEmpty)
    }
    func testFailDisplayText (){
       let dict = centerWelcomeJsonObject as NSDictionary
        self.centerWelcome = dict.centerWelcomeModel()
        let text = self.centerWelcome?.text
        XCTAssertFalse(text!.isEmpty)
    }
    func testSuccessYoutube(){
        let dict = centerWelcomeJsonObject as NSDictionary
        self.centerWelcome = dict.centerWelcomeModel()
        let mediaType = self.centerWelcome?.media?.type
        XCTAssertTrue(mediaType == "YOUTUBE")
    }
    func testFailYoutube(){
        let dict = centerWelcomeJsonObject as NSDictionary
        self.centerWelcome = dict.centerWelcomeModel()
        let mediaType = self.centerWelcome?.media?.type
        XCTAssertFalse(!(mediaType == "YOUTUBE"))
    }
    func testSuccessDisplayLegalText(){
        let dict = centerLegalJsonObject as NSDictionary
        self.centerLegal = dict.centerLegalModel()
        let legalText = self.centerLegal?.text
        XCTAssertTrue(!legalText!.isEmpty)
    }
    func testFailDisplayLegalText(){
        let dict = centerLegalJsonObject as NSDictionary
        self.centerLegal = dict.centerLegalModel()
        let legalText = self.centerLegal?.text
        XCTAssertFalse(legalText!.isEmpty)
    }
    func testSuccessValidLegalDate(){
        let dict = centerLegalJsonObject as NSDictionary
        self.centerLegal = dict.centerLegalModel()
        let legalDate = self.centerLegal?.updatedAt
        XCTAssertTrue(!legalDate!.isEmpty)
    }
    func testFailValidLegalDate(){
        let dict = centerLegalJsonObject as NSDictionary
        self.centerLegal = dict.centerLegalModel()
        let legalDate = self.centerLegal?.updatedAt
        XCTAssertFalse(legalDate!.isEmpty)
    }
    func testSuccessDisplayLegalDate(){
        let dict = centerLegalJsonObject as NSDictionary
        self.centerLegal = dict.centerLegalModel()
        let legalDate = self.centerLegal?.updatedAt?.dateformat()
        XCTAssertTrue(legalDate == "1970/01/19")
    }
    func testFailDisplayLegalDate(){
        let dict = centerLegalJsonObject as NSDictionary
        self.centerLegal = dict.centerLegalModel()
        let legalDate = self.centerLegal?.updatedAt?.dateformat()
        XCTAssertFalse(!(legalDate == "1970/01/19"))
    }
}
