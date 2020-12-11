import XCTest

class SentryAttachmentTests: XCTestCase {
    
    private class Fixture {
        let defaultContentType = "application/octet-stream"
        let contentType = "application/json"
        let filename = "logs.txt"
        let data = "content".data(using: .utf8)!
        let path: String
        
        let dataAttachment: Attachment
        let fileAttachment: Attachment
        
        init() {
            path = "path/to/\(filename)"
            
            dataAttachment = Attachment(data: data, filename: filename)
            fileAttachment = Attachment(path: path, filename: filename)
        }
    }
    
    private let fixture = Fixture()

    func testInitWithBytes() {
        let attachment = Attachment(data: fixture.data, filename: fixture.filename)
        
        XCTAssertEqual(fixture.data, attachment.data)
        XCTAssertEqual(fixture.filename, attachment.filename)
        XCTAssertEqual(fixture.defaultContentType, attachment.contentType)
        XCTAssertNil(attachment.path)
    }
    
    func testInitWithBytesWithContentType() {
        let attachment = Attachment(data: fixture.data, filename: fixture.filename, contentType: fixture.contentType)
    
        XCTAssertEqual(fixture.data, attachment.data)
        XCTAssertEqual(fixture.filename, attachment.filename)
        XCTAssertEqual(fixture.contentType, attachment.contentType)
        XCTAssertNil(attachment.path)
    }
    
    func testInitWithPath() {
        let attachment = Attachment(path: fixture.path)
    
        XCTAssertEqual(fixture.path, attachment.path)
        XCTAssertEqual(fixture.filename, attachment.filename)
        XCTAssertEqual(fixture.defaultContentType, attachment.contentType)
        XCTAssertNil(attachment.data)
    }
    
    func testInitWithEmptyPath() {
        let attachment = Attachment(path: "")
        
        XCTAssertEqual("", attachment.path)
        XCTAssertEqual("", attachment.filename)
        XCTAssertEqual(fixture.defaultContentType, attachment.contentType)
        XCTAssertNil(attachment.data)
    }
    
    func testInitWithPath_Filename() {
        let attachment = Attachment(path: fixture.filename)
    
        XCTAssertEqual(fixture.filename, attachment.path)
        XCTAssertEqual(fixture.filename, attachment.filename)
    }
    
    func testInitWithPath_FilenameWithSlash() {
        let path = "./\(fixture.filename)"
        let attachment = Attachment(path: path)
    
        XCTAssertEqual(path, attachment.path)
        XCTAssertEqual(fixture.filename, attachment.filename)
    }
    
    func testInitWithPath_PathIsADir() {
        let path = "a/dir//"
        let attachment = Attachment(path: path)
    
        XCTAssertEqual(path, attachment.path)
        XCTAssertEqual("dir", attachment.filename)
    }
    
    func testInitWithPathAndFilename() {
        let filename = "input.json"
        let attachment = Attachment(path: fixture.path, filename: filename)
    
        XCTAssertEqual(fixture.path, attachment.path)
        XCTAssertEqual(filename, attachment.filename)
        XCTAssertEqual(fixture.defaultContentType, attachment.contentType)
        XCTAssertNil(attachment.data)
    }
    
    func testInitWithPath_Filename_ContentType() {
        let attachment = Attachment(path: fixture.path, filename: fixture.filename, contentType: fixture.contentType)
        
        XCTAssertEqual(fixture.path, attachment.path)
        XCTAssertEqual(fixture.filename, attachment.filename)
        XCTAssertEqual(fixture.contentType, attachment.contentType)
    }
    
    func testHash() {
        let fixture2 = Fixture()
        XCTAssertEqual(fixture.dataAttachment.hash(), fixture2.dataAttachment.hash())
        XCTAssertEqual(fixture.fileAttachment.hash(), fixture2.fileAttachment.hash())
        
        XCTAssertNotEqual(Attachment(data: Data(), filename: fixture.filename).hash(), fixture.dataAttachment.hash())
    }
    
    func testIsEqualToSelf() {
        XCTAssertEqual(fixture.dataAttachment, fixture.dataAttachment)
        XCTAssertTrue(fixture.dataAttachment.isEqual(to: fixture.dataAttachment))
        
        XCTAssertEqual(fixture.fileAttachment, fixture.fileAttachment)
        XCTAssertTrue(fixture.fileAttachment.isEqual(to: fixture.fileAttachment))
    }
    
    func testIsNotEqualToOtherClass() {
        XCTAssertFalse(fixture.fileAttachment.isEqual(1))
    }

    func testIsEqualToOtherInstanceWithSameValues() {
        let fixture2 = Fixture()
        XCTAssertEqual(fixture.dataAttachment, fixture2.dataAttachment)
        XCTAssertEqual(fixture.fileAttachment, fixture2.fileAttachment)
    }
    
    func testIsNotEqual() {
        XCTAssertFalse(fixture.fileAttachment.isEqual(to: nil))
        XCTAssertNotEqual(Attachment(data: Data(), filename: ""), fixture.dataAttachment)
        XCTAssertNotEqual(Attachment(path: ""), fixture.fileAttachment)
        XCTAssertNotEqual(Attachment(data: fixture.data, filename: ""), fixture.dataAttachment)
        XCTAssertNotEqual(Attachment(data: fixture.data, filename: fixture.filename, contentType: ""), fixture.dataAttachment)
        
    }
}