import 'package:shared/shared.dart';

/// {@template user}
class User extends Equatable {

    const User({
        this.email,
        this.name,
        this.profileImage,
        this.aggregateVerifier,
        this.verifier,
        this.typeOfLogin,
        this.dappShare,
        this.idToken,
        this.oAuthIdToken,
        this.oAuthAccessToken,
    });

    /// `User` email
    final String? email;

    /// `User` name
    final String? name;
    
    /// `User` profileImage
    final String? profileImage;

    /// `User` aggregateVerifier
    final String? aggregateVerifier;
    
    /// `User` verifier
    final String? verifier;

    /// `User` typeOfLogin
    final String? typeOfLogin;

    /// `User` dappShare
    final String? dappShare;

    /// `User` idToken
    final String? idToken;

    /// `User` oAuthIdToken
    final String? oAuthIdToken;

    /// `User` oAuthAccessToken
    final String? oAuthAccessToken;

    @override
    List<Object?> get props =>
    [email, name, profileImage, aggregateVerifier, verifier, typeOfLogin, dappShare, idToken, oAuthIdToken, oAuthAccessToken];

    User copyWith({
        String? email,
        String? name,
        String? profileImage,
        String? aggregateVerifier,
        String? verifier,
        String? typeOfLogin,
        String? dappShare,
        String? idToken,
        String? oAuthIdToken,
        String? oAuthAccessToken,
    }) {
        return User(
            email: email ?? this.email,
            name: name ?? this.name,
            profileImage: profileImage ?? this.profileImage,
            aggregateVerifier: aggregateVerifier ?? this.aggregateVerifier,
            verifier: verifier ?? this.verifier,
            typeOfLogin: typeOfLogin ?? this.typeOfLogin,
            dappShare: dappShare ?? this.dappShare,
            idToken: idToken ?? this.idToken,
            oAuthIdToken: oAuthIdToken ?? this.oAuthIdToken,
            oAuthAccessToken: oAuthAccessToken ?? this.oAuthAccessToken,
        );
    }
}