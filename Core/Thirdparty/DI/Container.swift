/// Inversion of control container that can be used for resolving dependencies.
public class Container {

    enum ObjectLifetime {

        /// - The object is a Singleton, i.e. it is created only once and that single instance is used.
        case single

        /// - Each time an instance is requested, a new instance is created.
        case perRequest
    }

    public init() { }

    /// Dictionary that contains mappings between protocol/class names and factory methods that should be used.
    private var factories: [String: Any] = [:]

    /// Dictionary that contains mappings between protocol/class names and lifetimes of objects that are created.
    private var lifetimes: [String: ObjectLifetime] = [:]

    /// Dictionary that contains mappings between protocol/class names and singleton instances created.
    private var singletonObjects: [String: Any] = [:]

    /// Registers a factory for a specific protocol or class that should be called when a
    /// instance for a Singleton needs to be created.
    ///
    /// - Parameter factory: Factory method that should be used to create the instance.
    public func addSingleton<T>(factory: @escaping () -> T) {
        let key = register(factory: factory)

        lifetimes[key] = .single
    }

    /// Registers a factory for a specific protocol or class that should be called whenever an instance
    /// of the protocol/class is required.
    ///
    /// - Parameter factory: Factory method that should be used to create the instance.
    public func addPerRequest<T>(factory: @escaping () -> T) {
        let key = register(factory: factory)

        lifetimes[key] = .perRequest
    }

    /// Internal method that should be used to register a factory method.
    ///
    /// - Parameter factory: Factory method that should be registered.
    /// - Returns: Key of the registered factory method. Can be used to set a lifetime.
    private func register<T>(factory: @escaping () -> T) -> String {
        let parameterType = type(of: T.self)
        let key = String(describing: parameterType)

        factories[key] = factory
        return key
    }

    /// Resolves a dependency of a specific type. Introduces a fatal error in case the
    /// requested type is not registered.
    ///
    /// - Returns: Resolved intance that either is a instance of the class or conforms to a specific protocol.
    public func resolve<T>() -> T {
        let parameterType = type(of: T.self)
        let key = String(describing: parameterType)

        guard let factory = factories[key] as? () -> T, let lifetime = lifetimes[key] else {
            fatalError("Registration not found")
        }

        let result: T

        if lifetime == .perRequest {
            result = factory()
        } else if let singleton = singletonObjects[key] as? T {
            result = singleton
        } else {
            result = factory()
            singletonObjects[key] = result
        }

        return result
    }

    /// Removes all registrations and singleton instances. Very useful for testing.
    public func cleanup() {
        factories.removeAll()
        lifetimes.removeAll()
        singletonObjects.removeAll()
    }
}
