# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ContentBlockRegistry do
    subject { described_class.new }

    describe "register" do
      it "registers a content block" do
        register_block(:my_block)

        expect(subject.content_blocks.map(&:name)).to eq [:my_block]
      end

      it "raises an error if the content block is already registered" do
        register_block(:my_block)

        expect { subject.register(:my_block) {} }
          .to raise_error(described_class::ContentBlockAlreadyRegistered)
      end
    end

    def register_block(name)
      subject.register(name) do |content_block|
        content_block.cell "my/fake/cell"
      end
    end
  end
end
