# frozen_string_literal: true

require 'rails_helper'

TestHelper = Class.new(ActionView::Base)

describe FormBuilder, type: :helper do
  let(:resource) { build(:contact, full_name: nil, email: nil) }
  let(:helper) { TestHelper.new }
  let(:f) { FormBuilder.new(:contact, resource, helper, {}) }

  before { resource.valid? }

  describe '#group' do
    subject { f.group(:full_name, class: 'myClass') {} }

    context 'with resource error' do
      it 'appends class' do
        is_expected.to eq '<div class="myClass form-group-error"></div>'
      end
    end

    context 'without resource error' do
      before { resource.errors.clear }

      it 'does not append class' do
        is_expected.to eq '<div class="myClass"></div>'
      end
    end

    context 'without block argument' do
      subject { f.group(:full_name, class: 'myClass') }

      it 'needs block argument' do
        expect { subject }.to raise_error(ArgumentError, 'require a block')
      end
    end
  end

  describe '#error' do
    subject { f.error(:full_name) }

    context 'with resource error' do
      it 'return error message element' do
        allow(resource.errors).to receive(:full_messages_for) { ['Oops!'] }
        is_expected.to eq '<span class="error-message">Oops!</span>'
      end
    end

    context 'without resource error' do
      before { resource.errors.clear }
      it { is_expected.to be_nil }
    end

    context 'without method' do
      subject { f.error nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#hint' do
    context 'with text' do
      subject { f.hint 'This is a hint' }

      it 'returns hint element' do
        is_expected.to eq '<span class="form-hint">This is a hint</span>'
      end
    end

    context 'without text' do
      subject { f.hint nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#label' do
    let(:hint_html) { '<span class="form-hint">This is a hint</span>' }
    let(:error_html) { '<span class="error-message">Oops!</span>' }

    before do
      allow(resource.errors).to receive(:full_messages_for) { ['Oops!'] }
    end

    context 'with hint and resource error' do
      context 'with text' do
        subject { f.label(:full_name, 'Your name', hint: 'This is a hint') }

        it 'append hint after text label' do
          is_expected.to eq(
            '<label for="contact_full_name">Your name' + hint_html +
            error_html + '</label>'
          )
        end
      end

      context 'with block' do
        subject { f.label(:full_name, hint: 'This is a hint') { 'Name' } }

        it 'append hint after block label' do
          is_expected.to eq(
            '<label for="contact_full_name">Name' + hint_html +
            error_html + '</label>'
          )
        end
      end
    end

    context 'with hint and without resource error' do
      before { resource.errors.clear }

      context 'with text' do
        subject { f.label(:full_name, 'Your name', hint: 'This is a hint') }

        it 'append hint after text label' do
          is_expected.to eq(
            '<label for="contact_full_name">Your name' + hint_html + '</label>'
          )
        end
      end

      context 'with block' do
        subject { f.label(:full_name, hint: 'This is a hint') { 'Name' } }

        it 'append hint after block label' do
          is_expected.to eq(
            '<label for="contact_full_name">Name' + hint_html + '</label>'
          )
        end
      end
    end

    context 'without hint or resource error' do
      before { resource.errors.clear }

      context 'with text' do
        subject { f.label(:full_name, 'Your name') }

        it 'append hint after text label' do
          is_expected.to eq '<label for="contact_full_name">Your name</label>'
        end
      end

      context 'with block' do
        subject { f.label(:full_name) { 'Name' } }

        it 'append hint after block label' do
          is_expected.to eq '<label for="contact_full_name">Name</label>'
        end
      end
    end
  end
end
