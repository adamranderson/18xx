# frozen_string_literal: true

module View
  module Game
    class Ability < Snabberb::Component
      needs :company
      needs :selected_company, default: nil, store: true
      needs :game, store: true
      needs :tile_selector, default: nil, store: true
      needs :display, default: 'inline-block'

      def selected?
        @company == @selected_company
      end

      def ability_usable?
        return if (@company.all_abilities.map(&:type) & Round::Operating::ABILITIES).empty?

        @game.round.can_act?(@company.owner) || @company.owner.player?
      end

      def select_ability(event)
        event.JS.stopPropagation
        selected_company = (ability_usable?) && !selected? ? @company : nil
        store(:tile_selector, nil, skip: true)
        store(:selected_company, selected_company)
      end

      def toggle_desc(event, company)
        event.JS.stopPropagation
        display = Native(@hidden_divs[company.sym]).elm.style.display
        Native(@hidden_divs[company.sym]).elm.style.display = display == 'none' ? 'grid' : 'none'
      end

      def render
      	@hidden_divs = {}
        name_props = {
          style: {
            display: 'inline-block',
            cursor: 'pointer',
          },
          on: { click: ->(event) { toggle_desc(event, @company) } },
        }

        income_props = {
          style: {
            paddingRight: '0.3rem',
          },
        }

        hidden_props = {
          style: {
            display: 'none',
            gridColumnEnd: "span #{@company.owner.player? ? '3' : '2'}",
            marginBottom: '0.5rem',
            padding: '0.1rem 0.2rem',
            fontSize: '80%',
            cursor: ability_usable? ? 'pointer' : 'default',
          },
        }
        hidden_props[:on] = { click: ->(event) { select_company(event) } }
        if selected?
          hidden_props[:style]['background-color'] = 'lightblue'
          hidden_props[:style]['color'] = 'black'
          hidden_props[:style][:borderRadius] = '0.2rem'
        end

        @hidden_divs[@company.sym] = h('div#hidden', hidden_props, @company.desc)

        [h('div.name.nowrap', name_props, @company.name),
         @hidden_divs[@company.sym]]
      end
    end
  end
end
