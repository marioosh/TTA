class Card
  class Civil
    class Wonder
      class LinieOceaniczne < Wonder
        def stages; [3,2,2,2,3]; end

        # TODO: Raz na turę możesz zwiększyć swoją populację bez wydawania akcji cywilnej. Kosztuje Cię to 5 żywności mniej.
        def available_actions(type, phase, gc = nil)
          options = super
          # options[:special] = PlayerAction::Civil::IncreasePopulation if type == GameCard::PlayerCard && phase == Game::Civilization::Phase::ACTIONS
          return options
        end
      end
    end
  end
end