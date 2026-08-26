# HisabKitab Bengali Localization Contract

## Requirement

Bangla is a first-class product language, not a partial translation layer. Every user-facing function, button, label, message, form field, empty state, error, confirmation, onboarding step, receipt, invoice, notification, report heading, and settings option must have a reviewed Bengali version.

## Language strategy

- Bengali is available throughout the Owner Edition from the first release.
- English may remain available as an additional language, but no core feature may be English-only.
- User-facing Bengali must use natural, concise Bangladesh-appropriate business language.
- Technical/internal identifiers, source-code symbols, database keys, and developer logs may remain English.
- Customer-facing documents must support Bengali text correctly in PDF/print/share output.

## UX rules

- Prefer familiar terms used by Bangladeshi small-business owners.
- Avoid machine-translated or unnecessarily literary Bengali.
- Keep labels short enough for mobile controls.
- Use consistent terminology across screens and documents.
- Numbers, currency, dates, and units must be localized consistently while preserving exact financial meaning.
- Never mix Bengali and English arbitrarily when a clear Bengali term exists.
- Product/service names entered by the business remain user data and are not translated automatically.

## Terminology baseline

| English concept | Preferred Bengali |
|---|---|
| Dashboard | ড্যাশবোর্ড |
| Sale | বিক্রি |
| Sales | বিক্রয় |
| Product | পণ্য |
| Service | সেবা |
| Customer | ক্রেতা |
| Supplier | সরবরাহকারী |
| Purchase | ক্রয় |
| Expense | খরচ |
| Due | বাকি |
| Payment | পরিশোধ |
| Receive Payment | টাকা গ্রহণ |
| Profit | লাভ |
| Cost | খরচ |
| Selling Price | বিক্রয়মূল্য |
| Actual Cost | প্রকৃত খরচ |
| Invoice | চালান |
| Receipt | রসিদ |
| Quotation | মূল্যপ্রস্তাব |
| Return | ফেরত |
| Refund | টাকা ফেরত |
| Stock | মজুত |
| Report | প্রতিবেদন |
| Settings | সেটিংস |
| Save | সংরক্ষণ |
| Cancel | বাতিল |
| Search | খুঁজুন |
| Add | যোগ করুন |
| Continue | এগিয়ে যান |
| Complete Sale | বিক্রি সম্পন্ন করুন |
| More Details | আরও তথ্য |
| Optional | ঐচ্ছিক |
| Required | আবশ্যক |

Terminology may be refined during usability testing, but changes must be documented and applied consistently.

## Quality gate

Before release, perform a Bengali UI audit covering every reachable screen and every user action. A feature is not release-ready if its primary action, error state, or confirmation remains English-only.
