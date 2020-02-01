# frozen_string_literal: true

require 'snabberb/component'

require 'view/svg_tokens/ar'
require 'view/svg_tokens/ir'
require 'view/svg_tokens/ko'
require 'view/svg_tokens/ku'
require 'view/svg_tokens/sr'
require 'view/svg_tokens/tr'
require 'view/svg_tokens/ur'

# mapping of corporation short names to component classes for their token SVG
# representation
#
# TODO: how to handle different corporations with same short name? "same"
# corporation in different games, with different colors (e.g., PRR is green in
# 1830 vs red in 1846)?
TOKEN_SVG_COMPONENTS = {
  'AR' => View::SvgTokens::AR,
  'IR' => View::SvgTokens::IR,
  'KO' => View::SvgTokens::KO,
  'KU' => View::SvgTokens::KU,
  'SR' => View::SvgTokens::SR,
  'TR' => View::SvgTokens::TR,
  'UR' => View::SvgTokens::UR,
}.freeze

module View
  class Token < Snabberb::Component
    needs :token
    needs :radius

    def render
      svg_component = TOKEN_SVG_COMPONENTS[@token.corporation.sym]

      return render_text_token if svg_component.nil?

      h(:g, { attrs: { class: 'token', transform: "translate(-#{@radius} -#{@radius})" } }, [
          h(svg_component)
        ])
    end

    def render_text_token
      h(
        :text,
        { attrs: { 'text-anchor': 'middle' } },
        [@token.corporation.sym]
      )
    end
  end
end