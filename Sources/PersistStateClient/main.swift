#if os(macOS)
import Foundation
import PersistState

struct UserSettings {
    @Persisted var score: Int = 10
    @Persisted var username: String = "Guest"
}

var settings = UserSettings()

print("Initial score: \(settings.score)")
print("Initial username: \(settings.username)")

settings.score = 50
settings.username = "Mark"

print("Updated score: \(settings.score)")
print("Updated username: \(settings.score)")

#else
print("PersistStateClient requires the macOS host destination.")
#endif
