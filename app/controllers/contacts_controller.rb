class ContactsController < ApplicationController
  
  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  # POST request to /contacts
  def create
    # Mass assignment of form fields into contact object
    @contact = Contact.new(contact_param)
    # Save the contact object to the database
    if @contact.save
      # Store form fields via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into contact mailer and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message into flash hash
      # and redirect to new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # If contact object did not save,
      # stores error into flash hash,
      # and redirect to new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
    # To collect data from form we need to use 
    # strong parameters and whitelist the form fields
    def contact_param
      params.require(:contact).permit(:name, :email, :comments)
    end
end