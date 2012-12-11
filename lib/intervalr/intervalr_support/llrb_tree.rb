module IntervalrSupport
  class LlrbTree
    attr_accessor :root, :size

    def initialize
      self.size = 0
    end

    def find(key)
      node = find_node(key)
      node.nil? ? nil : node.value
    end
    alias_method :[], :find

    def exists?(key)
      find_node(key) != nil
    end

    def insert(key, value)
      self.root = insert_node(root, key, value)
      root.change_to_black
      self
    end
    alias_method :[]=, :insert

    def delete(key)
      return nil if root.nil?
      self.root = delete_node(root, key)
      root.change_to_black unless root.nil?
    end

    protected
    def is_red?(node)
      node.nil? ? nil : node.red?
    end

    def flip_colors(node)
      node.flip_color
      node.left.flip_color
      node.right.flip_color
    end

    def rotate_left(node)
      pivot = node.right
      raise 'Rotating a black node' if pivot.black?
      node.right = pivot.left
      pivot.left = node
      pivot.color = node.color
      node.change_to_red
      pivot
    end

    def rotate_right(node)
      pivot = node.left
      raise 'Rotating a black node' if pivot.black?
      node.left = pivot.right
      pivot.right = node
      pivot.color = node.color
      node.change_to_red
      pivot
    end

    def fix_up(node)
      node = rotate_left(node) if is_red?(node.right)
      node = rotate_right(node) if is_red?(node.left) && is_red?(node.left.left)
      flip_colors(node) if is_red?(node.left) && is_red?(node.right)
      node
    end

    def move_red_left(node)
      flip_colors node

      if is_red?(node.right.left)
        node.right = rotate_right(node.right)
        node = rotate_left(node)
        flip_colors node
      end

      node
    end

    def move_red_right(node)
      flip_colors node

      if is_red?(node.left.left)
        node = rotate_right(node)
        flip_colors node
      end

      node
    end

    def find_node(key)
      node = root
      until node == nil
        case key <=> node.key
          when 0 then return node
          when -1 then node = node.left
          else node = node.right
        end
      end

      nil
    end

    def insert_node(node, key, value)
      if node.nil?
        self.size += 1
        return LlrbNode.new(key, value)
      end

      case key <=> node.key
        when -1 then node.left = insert_node(node.left, key, value)
        when 1 then node.right = insert_node(node.right, key, value)
        else node.value = value
      end

      node = rotate_left(node) if is_red?(node.right) && !is_red?(node.left)
      node = rotate_right(node) if is_red?(node.left) && is_red?(node.left.left)
      flip_colors(node) if is_red?(node.left) && is_red?(node.right)

      node
    end

    def delete_min_node(node, min_node = nil)
      return [nil, nil] if node.nil?
      return [nil, node] if node.left.nil?

      node = move_red_left(node) if !is_red?(node.left) && !is_red?(node.left.left)

      node.left, min_node = delete_min_node(node.left)

      [fix_up(node), min_node]
    end

    def delete_node(node, key)
      return nil if node.nil?

      if key < node.key
        return nil if node.left.nil?

        node = move_red_left(node) if !is_red?(node.left) && !is_red?(node.left.left)
        node.left = delete_node(node.left, key)
      else
        node = rotate_right(node) if is_red?(node.left)

        if key == node.key && node.right.nil?
          self.size -= 1
          return nil
        end

        node = move_red_right(node) if !node.right.nil? && !is_red?(node.right) && !is_red?(node.right.left)

        if key == node.key
          node.right, min_node = delete_min_node(node.right)
          raise 'No min node' if min_node.nil?
          node.key = min_node.key
          node.value = min_node.value
          self.size -= 1
        else
          node.right = delete_node(node.right, key)
        end
      end

      fix_up(node)
    end

  end
end
