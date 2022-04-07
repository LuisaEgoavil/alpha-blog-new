# frozen_string_literal: true

class ArticleCategory < ApplicationRecord
  # add association: https://guides.rubyonrails.org/association_basics.html#the-has-many-through-association
  belongs_to :article
  belongs_to :category
end
