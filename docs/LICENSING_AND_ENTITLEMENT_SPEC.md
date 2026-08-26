# Licensing and Entitlement Specification

## 1. Purpose

Songjog may be distributed from a public source repository while commercial access remains controlled. Installing an APK or building the public source must not by itself grant a paid entitlement.

## 2. Identity

Authentication identifies the person/account. A business or institution is a separate workspace owned by one or more authorized accounts.

The platform owner is represented by a server-side role such as `PLATFORM_OWNER`. No master password, master activation code, or production secret may be embedded in the public source or APK.

## 3. Entitlement states

Recommended states:

- `trial`
- `active`
- `grace`
- `expired`
- `suspended`
- `cancelled`
- `revoked`

Entitlement is attached to a workspace/account relationship and has an auditable history.

## 4. Trial

A trial is created by the controlled backend. Trial duration is configurable (for example seven days or one month) and is not determined solely by a client-side clock.

Expiry must not delete, corrupt, or encrypt business data. The user must retain an appropriate export/recovery path.

## 5. Manual activation

For offline/manual sales, an administrator may issue a one-time activation code.

Flow:

`Authenticated account → redeem code → server validates → bind entitlement to workspace/account → mark code redeemed → cache minimum entitlement/session state securely`

Codes must be unpredictable, single-use according to policy, auditable, and invalidatable. A code must never contain or expose a reusable platform secret.

## 6. Subscription/payment

Payment providers are an implementation detail. Successful payment creates or extends an entitlement on the server. A webhook or verified server-side confirmation should be the authoritative payment signal.

The same entitlement model supports manual sales and automated subscriptions.

## 7. Returning user

After successful sign-in and activation, the client uses a secure persisted session. Users should not repeatedly paste activation codes.

Re-authentication may be required after explicit logout, account changes, security events, token expiry, or policy-defined risk conditions.

## 8. Offline operation

The Owner Edition should remain useful offline within a configurable policy. The client may cache only the minimum secure session/entitlement material necessary to honor that policy. When connectivity returns, the client reconciles with the server.

Offline grace must never be implemented as an irreversible client-side bypass.

## 9. Device changes

Entitlement belongs to the authorized account/workspace rather than permanently to one physical device. A permitted user can restore access on another device by authenticating again.

Optional device limits may be introduced as a separate policy.

## 10. Security requirements

Never commit:

- production API secrets
- payment gateway secrets
- OAuth client secrets
- private signing keys
- database credentials
- license-signing private keys
- administrator passwords
- reusable master activation codes

Client code is untrusted. Server authorization must be the source of truth for commercial entitlement.

## 11. Access control

Entitlement and authorization are separate concerns:

`Identity → Workspace membership → Role/permission → Entitlement → Feature access`

A paid subscription must not automatically grant administrative permissions.

## 12. Data safety

Expired, suspended, or cancelled access must not destroy accounting records. Read/export/recovery behavior is defined separately from commercial feature access.

## 13. Future payment integration

The implementation should expose a provider-neutral entitlement interface so payment providers can be added without changing accounting/domain logic.

## 14. Release acceptance criteria

- Public source/build cannot bypass commercial activation.
- Owner access is granted by server-side identity/role.
- Trial is server-controlled.
- Activation codes are redeemable according to policy and cannot be reused improperly.
- Returning users do not repeatedly paste codes.
- Payment confirmation updates entitlement safely.
- Revocation works.
- Reinstall/device replacement can recover authorized access.
- No production secret is present in the repository or APK.
- Business data survives entitlement expiry.
