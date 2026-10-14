class Fastmail
    Email = Struct.new(:id, :from, :subject, :received_at, :preview, keyword_init: true)

    SESSION_URL = "https://api.fastmail.com/jmap/session"
    CAPABILITIES = ["urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail"].freeze

    # Full list: https://jmap.io/spec-mail.html#properties-of-the-email-object
    EMAIL_FIELDS = %w[id from subject receivedAt preview].freeze

    def initialize(token)
        @token = token
    end

    def latest_emails(limit: 10)
        ids = email_ids_in(inbox_id, limit: limit)
        get_emails(ids)
    end

    def inbox_id
        @inbox_id ||= call("Mailbox/query", filter: { role: "inbox" })["ids"].first
    end

    def email_ids_in(mailbox_id, limit:)
        call("Email/query",
            filter: { inMailbox: mailbox_id },
            sort:   [{ property: "receivedAt", isAscending: false }],
            limit:  limit,
        )["ids"]
    end

    def get_emails(ids)
        result = call("Email/get", ids: ids, properties: EMAIL_FIELDS)
        result["list"].map do |data|
            Email.new(
                id:          data["id"],
                from:        data.dig("from", 0, "email"),
                subject:     data["subject"],
                received_at: Time.iso8601(data["receivedAt"]),
                preview:     parse_markdown(data["preview"].strip),
            )
        end
    end

    UNREAD = { notKeyword: "$seen" }.freeze

    def unread_emails(limit: 50)
        ids = call("Email/query",
            filter: { inMailbox: inbox_id, **UNREAD },
            sort:   [{ property: "receivedAt", isAscending: false }],
            limit:  limit,
        )["ids"]

        return get_emails(ids)
    end

    def unread_count
        call("Email/query",
            filter:         { inMailbox: inbox_id, **UNREAD },
            limit:          0,
            calculateTotal: true,
        )["total"]
    end

    private

    def session
        @session ||= request(Net::HTTP::Get, SESSION_URL)
    end

    def account_id
        session["primaryAccounts"]["urn:ietf:params:jmap:mail"]
    end

    def api_url
        session["apiUrl"]
    end

    # Runs one JMAP method and returns its result.
    # JMAP can batch several methods in one request,
    # so the wire format is a list of [method name, arguments, label] triples.
    # Only ever sending one, so the label ("0") doesn't matter.

    def call(method, **arguments)
        body = {
            using: CAPABILITIES,
            methodCalls: [[method, { accountId: account_id, **arguments }, "0"]]
        }

        name, result, _label = request(Net::HTTP::Post, api_url, body)["methodResponses"].first

        if name == "error"
            raise "#{method} failed: #{result['type']} #{result['description']}"
        end

        return result
    end

    def request(verb, url, body = nil)
        uri = URI(url)
        req = verb.new(uri)
        req["Authorization"] = "Bearer #{@token}"
        req["Content-Type"]  = "application/json"
        req.body = body.to_json if body

        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
        raise "HTTP #{res.code} from #{url}: #{res.body}" unless res.is_a?(Net::HTTPSuccess)

        return JSON.parse(res.body)
    end
end