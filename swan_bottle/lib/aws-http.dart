class AWS_HTTP {
  //variables
  static const String _region = "us-east-1";
  static const String _clientId = "24lrgc19hi6h0t8hcaf921p8i4";
  static const String _userPoolID = "us-east-1_AN8oSlpFu";
  static const String _url = "https://cognito-idp.us-east-1.amazonaws.com/";

  static const amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "$_userPoolID",
            "AppClientId": "$_clientId",
            "Region": "$_region"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "usernameAttributes": ["email"],
            "signupAttributes": [
              "email", "name"
             ],
            "passwordProtectionSettings": {
                "passwordPolicyMinLength": 8,
                "passwordPolicyCharacters": []
            }
          }
        }
      }
    }
  }
}''';

  String get region => _region;
  String get clientId => _clientId;
  String get url => _url;
  String get poolId => _userPoolID;
  String get config => amplifyconfig;

  // functions
  Map<String, String> genHeader(String target) {
    return {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.$target',
    };
  }
}
