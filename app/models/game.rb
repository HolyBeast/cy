class Game
  class State
    WAITING_FOR_PLAYERS = 1
    FINISHED            = 2
  end
 
  def accepts_new_player?
    state == State::WAITING_FOR_PLAYERS
  end
end