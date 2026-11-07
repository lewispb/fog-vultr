module Fog
  module Vultr
    class Compute
      # Vultr's list requests return a page at a time, with the next page's
      # cursor in meta.links.next. Collections use list_all to load every page.
      module Paging
        PER_PAGE = 500

        # Every item under key across the pages of a list request
        def list_all(request, key, *arguments, **query)
          items = []
          cursor = nil

          loop do
            body = public_send(request, *arguments, { per_page: PER_PAGE, cursor: cursor, **query }.compact).body
            items.concat(body.fetch(key))
            break if (cursor = next_cursor(body)).nil?
          end

          items
        end

        private
          def next_cursor(body)
            cursor = body.dig("meta", "links", "next")
            cursor unless cursor.to_s.empty?
          end
      end
    end
  end
end
