# frozen_string_literal: true

require 'engine/action/base'

module Engine
  module Action
    class Par < Base
      attr_reader :corporation, :share_price

      def initialize(entity, corporation, share_price)
        @entity = entity
        @corporation = corporation
        @share_price = share_price
      end

      def self.h_to_args(h, game)
        [game.corporation_by_id(h['corporation']), game.share_price_by_id(h['share_price'])]
      end

      def args_to_h
        {
          'corporation' => @corporation.id,
          'share_price' => @share_price.id,
        }
      end
    end
  end
end
