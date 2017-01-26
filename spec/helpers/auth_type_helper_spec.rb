require 'rails_helper'

describe AuthTypeHelper do
  let(:auth_type) { 'nyu' }
  let(:institution) { 'nyu' }
  let(:params) do
    {
      "auth_type" => auth_type,
      "institution" => institution
    }
  end
  before { allow(helper).to receive(:params).and_return(params) }

  describe '#auth_type_with_institution' do
    subject { helper.auth_type_with_institution }
    context 'when institution is a sub auth_type, i.e. nyuad' do
      let(:auth_type) { 'nyu' }
      let(:institution) { 'nyuad' }
      it { is_expected.to eql 'nyu.nyuad' }
    end
    context 'when institution is not a sub auth_type' do
      it { is_expected.to eql 'nyu' }
    end
  end

  describe '#password_field_help_text' do
    subject { helper.password_field_help_text }
    xcontext 'when the password field has help text' do
      let(:auth_type) { 'nysid' }
      it { is_expected.to include '<p class="help-block">' }
      it { is_expected.to include I18n.t("application.#{auth_type}.password_help_text") }
    end
    context 'when the password field does not have help text' do
      let(:auth_type) { 'dummy' }
      it { is_expected.to be_nil }
    end
  end
end
