import Factory

extension Container {

    var networkService: Factory<HTTPClientProtocol> {
        self { NetworkService() }
    }
}
