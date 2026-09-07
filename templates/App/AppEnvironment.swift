import Foundation

struct AppEnvironment {
    let aiClient: any AIClient
    let resultCache: any AIResultCache

    static func live() -> AppEnvironment {
        AppEnvironment(
            aiClient: DefaultAIClient(),
            resultCache: InMemoryAIResultCache()
        )
    }
}
