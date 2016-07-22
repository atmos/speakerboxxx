# rubocop:disable Metrics/LineLength
module OmniAuthHelpers
  def github_omniauth_hash_for_atmos
    user_info = {
      name: "Corey Donohoe",
      nickname: "atmos",
      avatar_url: "https://avatars.githubusercontent.com/u/38?v=3"
    }

    credentials = {
      token: SecureRandom.hex(24)
    }

    OmniAuth::AuthHash.new(provider: "github",
                           uid: "38",
                           info: user_info,
                           credentials: credentials)
  end

  def github_omniauth_hash_for_toolskai
    user_info = {
      name: "Tools Helper",
      nickname: "toolskai",
      avatar_url: "https://avatars.githubusercontent.com/u/9364088?v=3"
    }

    credentials = {
      token: SecureRandom.hex(24)
    }

    OmniAuth::AuthHash.new(provider: "github",
                           uid: "38",
                           info: user_info,
                           credentials: credentials)
  end

  # rubocop:disable Metrics/MethodLength
  def slack_omniauth_hash_for_atmos
    info = {
      description: nil,
      email: "atmos@atmos.org",
      first_name: "Corey",
      last_name: "Donohoe",
      image: "https://secure.gravatar.com/avatar/a86224d72ce21cd9f5bee6784d4b06c7.jpg?s=192&d=https%3A%2F%2Fslack.global.ssl.fastly.net%2F7fa9%2Fimg%2Favatars%2Fava_0010-192.png",
      image_48: "https://secure.gravatar.com/avatar/a86224d72ce21cd9f5bee6784d4b06c7.jpg?s=48&d=https%3A%2F%2Fslack.global.ssl.fastly.net%2F66f9%2Fimg%2Favatars%2Fava_0010-48.png",
      is_admin: true,
      is_owner: true,
      name: "Corey Donohoe",
      nickname: "atmos",
      team: "Zero Fucks LTD",
      team_id: "T123YG08V",
      time_zone: "America/Los_Angeles",
      user: "atmos",
      user_id: "U123YG08X"
    }
    credentials = {
      token: SecureRandom.hex(24)
    }
    extra = {
      raw_info: {
        ok: true
      },
      bot_info: {
        bot_access_token: "xoxo-hugs-n-kisses",
        bot_user_id: "U421FY7"
      }
    }

    OmniAuth::AuthHash.new(provider: "slack",
                           uid: "U024YG08X",
                           info: info,
                           extra: extra,
                           credentials: credentials)
  end

  def slack_omniauth_hash_for_toolskai
    info = {
      provider: "slack",
      uid: nil,
      info: {
      },
      credentials: {
        token: "xoxp-9101111159-5657146422-59735495733-3186a13efg",
        expires: false
      },
      extra: {
        raw_info: {
          ok: false,
          error: "missing_scope",
          needed: "identify",
          provided: "identity.basic"
        },
        web_hook_info: {
        },
        bot_info: {
        },
        user_info: {
          ok: false,
          error: "missing_scope",
          needed: "users:read",
          provided: "identity.basic"
        },
        team_info: {
          ok: false,
          error: "missing_scope",
          needed: "team:read",
          provided: "identity.basic"
        }
      }
    }
    OmniAuth::AuthHash.new(info)
  end
  # rubocop:enable Metrics/MethodLength

  def create_atmos
    slack = slack_omniauth_hash_for_atmos
    team = SlackHQ::Team.from_omniauth(slack)

    user = team.users.find_or_initialize_by(
      slack_user_id: slack.info.user_id,
      slack_user_name: slack.info.nickname
    )
    user.save
    user
  end
end
# rubocop:enable Metrics/LineLength
