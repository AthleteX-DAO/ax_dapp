/// Default value for an empty `Ethereum` address.
///
/// `0x0000000000000000000000000000000000000000` is not set as default because:
/// - it could cause a potentially invalid request to succeed;
/// - it opens up the door to different hack opportunities.
const kEmptyAddress = '';

/// This address is not owned by any user, is often associated with token
/// burn & mint/genesis events and used as a generic null address
const kNullAddress = '0x0000000000000000000000000000000000000000';
