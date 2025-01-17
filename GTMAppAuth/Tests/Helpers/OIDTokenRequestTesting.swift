/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Ensure that we import the correct dependency for both SPM and CocoaPods since
// the latter doesn't define separate Clang modules for subspecs
#if SWIFT_PACKAGE
import AppAuthCore
#else
import AppAuth
#endif

/// Protocol for creating a test instance of `OIDTokenRequest` with additional parameters.
@objc public protocol TokenRequestTesting: Testing {
  static func testInstance(additionalParameters: [String: String]?) -> Self
}

@objc extension OIDTokenRequest: TokenRequestTesting {
  public static func testInstance() -> Self {
   testInstance(additionalParameters: nil)
  }

  public static func testInstance(additionalParameters: [String : String]?) -> Self {
    let authorizationResponse = OIDAuthorizationResponse.testInstance()
    let authorizationRequest = authorizationResponse.request
    let scopes = OIDScopeUtilities.scopesArray(
      with: authorizationRequest.scope ?? ""
    )
    return OIDTokenRequest(
      configuration: authorizationResponse.request.configuration,
      grantType: OIDGrantTypeAuthorizationCode,
      authorizationCode: authorizationResponse.authorizationCode,
      redirectURL: authorizationRequest.redirectURL,
      clientID: authorizationRequest.clientID,
      clientSecret: authorizationRequest.clientID,
      scopes: scopes,
      refreshToken: "refreshToken",
      codeVerifier: authorizationRequest.codeVerifier,
      additionalParameters: additionalParameters,
      additionalHeaders: nil
    ) as! Self
  }
}
