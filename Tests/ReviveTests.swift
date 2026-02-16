import XCTest
@testable import Revive

final class ReviveTests: XCTestCase {
    
    // MARK: - Content Database Tests
    func testContentDatabaseLoading() {
        // Given
        let db = ContentDatabase.shared
        
        // When
        // (Database loads on init)
        
        // Then
        XCTAssertFalse(db.techniques.isEmpty, "Techniques should not be empty")
        XCTAssertFalse(db.homeTools.isEmpty, "Tools should not be empty")
    }
    
    func testTechniqueStructure() {
        // Given
        let db = ContentDatabase.shared
        
        // When
        let cpr = db.techniques.first { $0.id == "firstaid-cpr" }
        
        // Then
        XCTAssertNotNil(cpr, "CPR technique should exist")
        XCTAssertNotNil(cpr?.steps, "CPR should have steps")
        XCTAssertTrue(cpr!.steps.count > 0, "CPR should have at least one step")
    }
    
    // MARK: - Settings Service Tests
    func testSettingsPersistence() {
        // Given
        let settings = SettingsService.shared
        let originalValue = settings.isMetric
        
        // When
        settings.isMetric.toggle()
        
        // Then
        XCTAssertNotEqual(settings.isMetric, originalValue, "Settings should toggle")
        
        // Cleanup
        settings.isMetric.toggle()
    }
}
