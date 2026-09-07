import Foundation
@testable import SwiftUIAIStarter

actor FakeAIClient: AIClient {
    private(set) var callCount = 0
    private var results: [Result<AIClientResponse, FakeAIClientError>]
    private let delay: Duration?

    init(
        results: [Result<AIClientResponse, FakeAIClientError>],
        delay: Duration? = nil
    ) {
        precondition(!results.isEmpty)
        self.results = results
        self.delay = delay
    }

    func perform(request: AIRequest, context: AIRequestContext) async throws -> AIClientResponse {
        callCount += 1
        if let delay {
            try await Task.sleep(for: delay)
        }

        let result = results.count == 1 ? results[0] : results.removeFirst()
        switch result {
        case let .success(response):
            return response
        case .failure(.cancelled):
            throw CancellationError()
        case let .failure(error):
            throw error
        }
    }
}
