class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key)
    end

    def decode(token)
      body = JWT.decode(token, secret_key)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
    
    private
    def secret_key
      Rails.application.credentials.secret_key_base
    end
  end
end