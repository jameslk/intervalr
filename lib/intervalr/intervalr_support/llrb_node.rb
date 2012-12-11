module IntervalrSupport
  class LlrbNode
    attr_accessor :left, :right, :color, :key, :value

    RED_NODE = true
    BLACK_NODE = false

    def initialize(key, value)
      self.key, self.value = key, value
      change_to_red
    end

    def change_to_red
      self.color = RED_NODE
    end

    def change_to_black
      self.color = BLACK_NODE
    end

    def flip_color
      self.color = !color
    end

    def red?
      color == RED_NODE
    end

    def black?
      color == BLACK_NODE
    end

  end
end