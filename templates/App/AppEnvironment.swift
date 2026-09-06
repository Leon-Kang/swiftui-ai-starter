import Foundation

struct AppEnvironment {
    let aiClient: AIClient
    let resultCache: AIResultCache

    static func live() -> AppEnvironment {
        AppEnvironment(
            aiClient: DefaultAIClient(),
            resultCache: InMemoryAIResultCache()
        )
    }
}
