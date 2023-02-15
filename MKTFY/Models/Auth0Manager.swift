//
//  Auth0Manager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/15.
//

import Auth0

class Auth0Manager {
    
    func loginWithEmail(_ email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let auth0 = Auth0.authentication()
        
        auth0.login(
            usernameOrEmail: email,
            password: password,
            realmOrConnection: "Username-Password-Authentication",
            audience: "https://dev-vtoay0l3h78iuz2e.us.auth0.com/api/v2/",
            scope: "openid profile"
        )
        .start { result in
            switch result {
            case .success(let credentials):
                print("Authenticated with Auth0: \(credentials)")
                completion(true, nil)
            case .failure(let error):
                print("Failed to authenticate with Auth0: \(error)")
                completion(false, error)
            }
        }
    }
    
}
