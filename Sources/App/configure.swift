import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import WebAuthn

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
	
	app.middleware.use(app.sessions.middleware)

	app.databases.use(DatabaseConfigurationFactory.postgres(configuration: SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
	
	app.sessions.use(.fluent)

    app.migrations.add(CreateTodo())
	
	app.migrations.add(CreateUser())
	app.migrations.add(CreateWebAuthn())
	
	try await app.autoMigrate()
	
	let domain = "0774-2001-1388-19e9-8f87-2c36-13d6-4004-5a2b.ngrok-free.app"
	app.webAuthn = WebAuthnManager(config: WebAuthnManager.Config(relyingPartyID: "\(domain)", relyingPartyName: "ShinyAPI", relyingPartyOrigin: "https://\(domain)"))
	
    // register routes
    try routes(app)
}
