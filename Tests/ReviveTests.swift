import XCTest
@testable import Revive

final class ReviveTests: XCTestCase {
    
    func testContentDatabaseLoading() {
        let db = ContentDatabase.shared
        
        // (Database loads on init)
        
        XCTAssertFalse(db.techniques.isEmpty, "Techniques should not be empty")
        XCTAssertFalse(db.homeTools.isEmpty, "Tools should not be empty")
    }
    
    func testTechniqueStructure() {
        let db = ContentDatabase.shared
        
        let cpr = db.techniques.first { $0.id == "firstaid-cpr" }
        
        XCTAssertNotNil(cpr, "CPR technique should exist")
        XCTAssertNotNil(cpr?.steps, "CPR should have steps")
        XCTAssertTrue(cpr!.steps.count > 0, "CPR should have at least one step")
    }
    
    func testSettingsPersistence() {
        let settings = SettingsService.shared
        let originalValue = settings.isMetric
        
        settings.isMetric.toggle()
        
        XCTAssertNotEqual(settings.isMetric, originalValue, "Settings should toggle")
        
        settings.isMetric.toggle()
    }
}
