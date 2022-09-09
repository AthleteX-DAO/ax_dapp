/// Gysr queries.
abstract class GysrQuery {
  /// Get all farms query.
  static const getAllFarms = r'''
    query getAllFarms($owner: String!) {
      pools(where: {owner_contains: $owner}) {
        id
        name
        apr
        tvl
        stakingToken {
          id
          alias
          price
          symbol
          decimals
        }
        rewardToken {
          id
          alias
          price
          symbol
          decimals
        }
        staked
        rewards
        owner {
          id
        }
        stakingModule
      }
    }
  ''';

  /// Get staked farms query.
  static const getStakedFarms = r'''
    query getStakedFarms($account: String!) {
      user(id: $account) {
        positions {
          pool {
            id
            name
            apr
            tvl
            stakingToken {
              id
              alias
              price
              symbol
              decimals
            }
            rewardToken {
              id
              alias
              price
              symbol
              decimals
            }
            staked
            rewards
            owner {
              id
            }
            stakingModule
          }
        }
      }
    }
  ''';
}
