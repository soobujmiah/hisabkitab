# Public Repository + Commercial Activation

## Product rule

The repository may be public while the released application remains commercially controlled. Installing an APK must not by itself grant access to the Owner Edition.

## Activation model

1. User installs the application.
2. First launch shows the activation/account entry flow.
3. User signs in once with the Songjog account.
4. The account is associated with a Business identity.
5. A valid trial or paid entitlement is checked by the licensing service.
6. After successful authentication and entitlement verification, the app creates a secure local session.
7. On subsequent launches the user should normally enter directly into the app; they must not repeatedly paste an activation code.
8. Explicit logout, account change, security events, or an expired/revoked entitlement may require authentication again.

## Activation code

For manually sold licenses, an activation code may be redeemed once while signed in. The code is then bound server-side to the intended account/business and entitlement. Do not store a master activation secret in the public repository or APK.

## Public repository security

Never put production secrets, signing keys, API private keys, payment gateway secrets, admin credentials, license signing secrets, or database credentials in the public repository.

Client-side code is considered observable and therefore cannot be trusted as the sole licensing authority. Entitlement state must be verified against a controlled backend when connectivity is available.

## Offline behavior

A previously authenticated and authorized user may continue normal permitted offline operation according to the configured license/offline policy. The app should cache only the minimum secure session/entitlement material needed for this purpose and reconcile when online.

## Data safety

Activation failure or expiry must never delete or corrupt business data. Export and account recovery remain available according to the licensing policy.

## Release architecture

Public source repository
→ build artifact
→ application
→ authentication
→ business identity
→ entitlement service
→ authorized session
→ Owner Edition

The accounting engine must not contain hard-coded commercial credentials. Licensing is an entitlement boundary around the product, not a replacement for financial data integrity.

## Acceptance criteria

- Public APK installation alone cannot activate the paid Owner Edition.
- First-time activation requires authenticated account ownership and valid trial/license entitlement.
- Returning users do not repeatedly paste codes.
- Manual activation codes are single-use/redeemable according to server policy.
- A code cannot expose or grant another business's data.
- Logout/revocation works.
- Reinstall/device replacement can recover access through the authenticated account when entitlement permits.
- No production secret is committed to the public repository.
