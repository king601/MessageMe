class ContactGroupsController < ApplicationController
  before_action :authenticate_user!

  def create
    @contact = Contact.find(params[:contact_id])

    if params[:group_id].blank?
      redirect_to contacts_path, notice: "Sorry you must select a group to add #{@contact.first_name + " " + @contact.last_name} to."
    else
      @group = Group.find(params[:group_id])
      ContactGroup.find_or_create_by(contact: @contact, group: @group)
      redirect_to contacts_path, notice: "Added #{@contact.first_name} to #{@group.name}"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @contact_group = ContactGroup.find_by(contact: params[:id], group: @group)
    @contact_group.destroy
    redirect_to root_path, notice: "Contact has been removed from that group"
  end
end
