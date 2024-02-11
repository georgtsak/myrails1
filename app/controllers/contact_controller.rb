class ContactController < ApplicationController
  def create
    if user_signed_in?
      initiator_id = current_user.id
      recepient_id = params[:recepient_id]

      Contact.add_friend(initiator_id, recepient_id) # kaleitai h methodos add_friend(), h opoia exei oristei sto model tou contact
      redirect_to message_path, notice: "Contact added successfully!"
    else
      redirect_to new_user_session_path #anakateuthinsh sto login
    end
  end
end
