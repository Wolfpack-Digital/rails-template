class UserSerializer < ApplicationSerializer
  attributes :id, :first_name, :last_name, :email

  attributes :tokens, if: proc { params[:with_tokens] }

  attribute :message, if: proc { params[:with_message].present? } do
    params[:with_message]
  end
end
