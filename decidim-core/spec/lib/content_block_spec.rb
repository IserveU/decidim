# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ContentBlock do
    subject { described_class.new(attributes) }

    let(:name) { :my_block }
    let(:cell) { "my/fake/cell" }
    let(:attributes) do
      {
        name: name,
      }
    end

    before do
      subject.cell cell
    end

    it { is_expected.to be_valid }

    context "without a name" do
      let(:name) { nil }

      it { is_expected.not_to be_valid }
    end

    context "without a cell" do
      let(:cell) { nil }

      it { is_expected.not_to be_valid }
    end

    context "with repeated images" do
      it "is not valid" do
        subject.image :image
        subject.image :image

        expect(subject).not_to be_valid
      end
    end

    describe "initializing via a block" do
      let(:attributes) { { name: name } }

      it "is valid" do
        setup = Proc.new do |content_block|
          content_block.image :image_1
          content_block.image :image_2
          content_block.cell cell
        end

        setup.call(subject)
        expect(subject).to be_valid
        expect(subject.cell_name).to eq cell
        expect(subject.name).to eq name
        expect(subject.image_names).to match_array [:image_1, :image_2]
      end
    end
  end
end
