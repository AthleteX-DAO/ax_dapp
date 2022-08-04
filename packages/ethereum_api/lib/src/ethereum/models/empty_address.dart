/// Default value for an empty `Ethereum` address.
///
/// `0x0000000000000000000000000000000000000000` is not set as default because:
/// - it could cause a potentially invalid request to succeed;
/// - it opens up the door to different hack opportunities.
const kEmptyAddress = '';
