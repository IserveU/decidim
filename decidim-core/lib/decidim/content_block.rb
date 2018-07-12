# frozen_string_literal: true

module Decidim
  class ContentBlock
    include ActiveModel::Model
    include Virtus.model

    attribute :name, Symbol
    attribute :cell_name, String, writer: :private
    attribute :image_names, Array[Symbol]

    validates :name, :cell_name, presence: true
    validate :image_names_are_unique

    def image(name)
      image_names << name
    end

    def cell(cell_name)
      self.cell_name = cell_name
    end

    private

    def image_names_are_unique
      errors.add(:image_names, :invalid) if image_names.count != image_names.uniq.count
    end

    class ImageAlreadyRegistered < StandardError; end
  end
end
