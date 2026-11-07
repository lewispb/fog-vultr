module Fog
  module Vultr
    class Compute
      # Talks to Vultr's API with the account's key. A request Vultr rate
      # limits (429) is retried after each of retry_delays, whatever its
      # method, since Vultr turned it away unprocessed. A 5xx or a dropped
      # connection is retried the same way for GET, PUT and DELETE only, so a
      # create is never sent twice. Any other error status raises
      # Fog::Vultr::Compute::NotFound (404) or Fog::Vultr::Compute::Error, with
      # Vultr's message.
      class Real
        include Paging

        URL = "https://api.vultr.com"
        RETRY_DELAYS = [ 1, 2, 4 ]
        IDEMPOTENT = [ :get, :put, :delete ]
        RETRIED = [ Excon::Error::TooManyRequests, Excon::Error::Server, Excon::Error::Socket, Excon::Error::Timeout ]

        def initialize(options = {})
          @api_key = options.fetch(:vultr_api_key)
          @retry_delays = options.fetch(:retry_delays, RETRY_DELAYS)
          @connection = Fog::Core::Connection.new(
            options.fetch(:vultr_url, URL), options.fetch(:persistent, false), options.fetch(:connection_options, {})
          )
        end

        def request(method:, path:, expects:, query: nil, body: nil)
          with_retries(method) do
            decode @connection.request(
              method: method, path: "/v2/#{path}", query: query, expects: expects, headers: headers,
              body: body && Fog::JSON.encode(body)
            )
          end
        rescue Excon::Error::HTTPStatus => error
          raise error_for(error.response)
        end

        def reload
          @connection.reset
        end

        private
          def headers
            {
              "Authorization" => "Bearer #{@api_key}",
              "Accept" => "application/json",
              "Content-Type" => "application/json",
              "User-Agent" => "fog-vultr/#{VERSION} fog-core/#{Fog::Core::VERSION}"
            }
          end

          def with_retries(method)
            delays = @retry_delays.dup

            begin
              yield
            rescue *RETRIED => error
              raise unless retried?(method, error) && (delay = delays.shift)

              sleep delay
              retry
            end
          end

          def retried?(method, error)
            error.is_a?(Excon::Error::TooManyRequests) || IDEMPOTENT.include?(method)
          end

          def decode(response)
            response.body = Fog::JSON.decode(response.body) unless response.body.to_s.empty?
            response
          end

          def error_for(response)
            message = "#{response.status} #{message_in(response.body)}".strip
            response.status == 404 ? NotFound.new(message) : Error.new(message)
          end

          def message_in(body)
            Fog::JSON.decode(body).fetch("error", body)
          rescue Fog::JSON::DecodeError
            body
          end
      end
    end
  end
end
