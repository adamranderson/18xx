# frozen_string_literal: true

require 'view/game/ability'

module View
  module Game
    class Abilities < Snabberb::Component
      needs :game
      needs :user, default: nil
      needs :owner, default: nil

      def render
        companies = @owner.companies.flat_map do |c|
          h(Ability, company: c)
        end

        table_props = {
          style: {
            padding: '0 0.5rem',
            grid: @owner.player? ? 'auto / 4fr 1fr 1fr' : 'auto / 5fr 1fr',
            gap: '0 0.2rem',
          },
        }

        h('div#abilities_table', table_props, [
          h('div.bold', 'Ability'),
          *companies,
        ])
      end
    end
  end
end
