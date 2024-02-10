class ContactController < ApplicationController
  def create
    initiator_id = current_user.id
    recipient_id = params[:recipient_id]

    Contact.add_friend(initiator_id, recipient_id) #kaleitai h methodos add_friend(), h opoia exei oristei sto model tou contact

    redirect_to users_path, notice: "Contact added successfully!"
  end
end
