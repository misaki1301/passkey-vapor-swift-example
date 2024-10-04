//
//  File.swift
//  
//
//  Created by Paul Frank on 14/06/24.
//

import Vapor
import WebAuthn

extension Application {
	
	struct WebAuthnKey: StorageKey {
		typealias Value = WebAuthnManager
		
		
	}
	
	var webAuthn: WebAuthnManager {
		get {
			guard let webAuthn = storage[WebAuthnKey.self] else {
				fatalError("WebAuthn configured failed")
			}
			return webAuthn
		}
		set {
			storage[WebAuthnKey.self] = newValue
		}
	}
}

extension Request {
	var webAuthn: WebAuthnManager { application.webAuthn }
}
