# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ContentBlockRegistry do
    subject { described_class.new }

    describe "register" do
      it "registers a content block" do
        subject.register(:my_block) {}

        expect(subject.content_blocks.map(&:name)).to eq [:my_block]
      end

      it "raises an error if the content block is already registered" do
        subject.register(:my_block) {}

        expect { subject.register(:my_block) {} }
          .to raise_error(described_class::ContentBlockAlreadyRegistered)
      end
    end
  end
end
