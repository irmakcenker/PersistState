import XCTest

#if os(macOS)
import PersistState
#endif

final class PersistStateTests: XCTestCase {
    #if os(macOS)
    private final class TestSettings {
        @Persisted var age: Int = 25
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "age")
        super.tearDown()
    }

    func testPersistedReturnsDefaultValue() {
        UserDefaults.standard.removeObject(forKey: "age")

        let settings = TestSettings()

        XCTAssertEqual(settings.age, 25)
    }

    func testPersistedStoresAndReadsNewValue() {
        UserDefaults.standard.removeObject(forKey: "age")
        let settings = TestSettings()

        settings.age = 42

        XCTAssertEqual(settings.age, 42)
        XCTAssertEqual(TestSettings().age, 42)
    }
    #else
    func testPersistedTestsRequireMacOSHostMacroSupport() throws {
        throw XCTSkip("Persisted macro tests require the macOS host destination.")
    }
    #endif
}
