class Card
  class Civil
    class Wonder < Civil
      def available_actions(type, phase, gc = nil)
        options = super
        options[:build] = PlayerAction::Civil::BuildWonder if type == GameCard::PlayerWonder && phase == Game::Civilization::Phase::ACTIONS
        return options
      end

      def cost_resources(gc)
        return stages[gc.yellow_tokens]
      end

      def after_build(gc)
        gc.player.blue_tokens += self.blue_tokens(gc) if self.respond_to?(:blue_tokens)
        gc.player.yellow_tokens += self.yellow_tokens(gc) if self.respond_to?(:yellow_tokens)
        gc.player.save
      end
    end
  end
end