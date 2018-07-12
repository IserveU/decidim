# frozen_string_literal: true

module Decidim
  # This class acts as a registry for content blocks.
  #
  # A content block is a section in the home page. Those sections can be
  # registered by Decidim modules, and are configurable and sortable. They are a
  # useful way to customize the home page, without having to rely on overwriting
  # the views files. Also, this system is more powerful than basic view hooks
  # (see the `ViewHooks` class for reference), as view hooks don't have a way to
  # explicitly control the order of the hooked views.
  #
  # Content blocks are intended to be used in the home page, and only there.
  #
  # A content block has a set of options and an associated `cell` that will
  # handle the layout logic. They can also have attached images that can be used
  # as background images, for example. You must explicitly specify the number of
  # images the block will have (this means the number of attached images cannot
  # be configurable). Each content block is identified by a unique name.
  #
  # In order to register a content block, you can follow this example:
  #
  #     Decidim.content_blocks.register(:global_stats) do |content_block|
  #       content_block.option :minimum_priority_level,
  #                         :integer
  #                         default: lambda { StatsRegistry::HIGH_PRIORITY }
  #                         values: lambda { [StatsRegistry::HIGH_PRIORITY, StatsRegistry::MEDIUM_PRIORITY] }
  #       content_block.cell "decidim/content_blocks/stats_block"
  #     end
  #
  # Content blocks can also register attached images. Here's an example of a
  # content block with 4 attached images:
  #
  #     Decidim.content_blocks.register(:carousel) do |content_block|
  #       content_block.image :image_1
  #       content_block.image :image_2
  #       content_block.image :image_3
  #       content_block.image :image_4
  #       content_block.cell "decidim/content_blocks/carousel_block"
  #     end
  class ContentBlockRegistry
    # Public: Registers a content block for the home page.
    #
    # name - a symbol representing the name of the content block
    # &block - The content block definition.
    #
    # Returns nothing. Raises an error if there's already a content block
    # registered with that name.
    def register(name, &block)
      block_exists = content_blocks.any? { |content_block| content_block.name == name }
      raise ContentBlockAlreadyRegistered, "There's a block already registered with the name #{name}, must be unique" if block_exists

      content_block = ContentBlock.new(name)
      block.call(content_block)
      content_blocks.push(content_block)
    end

    def content_blocks
      @content_blocks ||= []
    end

    # Internal class to encapsulate each view registered on a view hook.
    class ContentBlock
      # name - a unique name identifying the content block
      def initialize(name)
        @name = name
      end

      attr_reader :name
    end

    class ContentBlockAlreadyRegistered < StandardError; end
  end
end
