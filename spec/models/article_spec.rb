# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#create" do
    context "with params valid" do
      it "returns an article" do
        expect { FactoryBot.create(:article) }.to change { Article.count }.from(0).to(1)
      end
    end

    context "with params not valid" do
      it 'raises a not found error' do
        expect { FactoryBot.create(:article, title: 'bla', body: 'ops') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
